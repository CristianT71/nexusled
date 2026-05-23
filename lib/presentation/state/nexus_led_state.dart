import 'package:flutter/foundation.dart';

import '../../data/models/led_event_model.dart';
import '../../data/models/mqtt_config_model.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/register_data_model.dart';
import '../../data/models/support_ticket_model.dart';
import '../../data/services/camera_service.dart';
import '../../data/services/local_config_service.dart';
import '../../data/services/mqtt_service.dart';
import '../../data/services/permission_service.dart';
import '../../data/services/supabase_service.dart';

enum AppSection {
  dashboard,
  control,
  statistics,
  about,
  services,
  systemInfo,
  connections,
  settings,
  httpSettings,
  otherProtocols,
  support,
  profile,
}

extension AppSectionDetails on AppSection {
  String get title {
    return switch (this) {
      AppSection.dashboard => 'Dashboard',
      AppSection.control => 'Control LED',
      AppSection.statistics => 'Estadísticas',
      AppSection.about => 'Quiénes Somos',
      AppSection.services => 'Servicios',
      AppSection.systemInfo => 'Información del Sistema',
      AppSection.connections => 'Conexiones',
      AppSection.settings => 'Configuración MQTT',
      AppSection.httpSettings => 'Configuración HTTP',
      AppSection.otherProtocols => 'Otros Protocolos',
      AppSection.support => 'Soporte y Ayuda',
      AppSection.profile => 'Perfil de Usuario',
    };
  }
}

class NexusLedState extends ChangeNotifier {
  bool authenticated = false;
  bool ledOn = false;
  bool mqttConnected = false;
  bool simulatorActive = false;
  bool sidebarExpanded = true;
  bool loading = false;
  String? lastError;
  DateTime stateSince = DateTime.now();
  AppSection section = AppSection.dashboard;
  int messagesSent = 0;
  int messagesReceived = 0;
  int latencyMs = 0;
  String ledColor = "white";
  ProfileModel? profile;
  final mqttConfig = MqttConfigModel();
  final _localConfig = LocalConfigService();
  final _mqtt = MqttService();
  final _supabase = SupabaseService();
  final _camera = CameraService();
  final _permissions = PermissionService();
  final events = <LedEventModel>[];

  Future<void> initialize() async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      await _supabase.initialize();
      authenticated = _supabase.authenticated;
      if (authenticated) {
        await _syncRemoteMqttConfig();
        await _localConfig.save(mqttConfig);
      } else {
        await _localConfig.load(mqttConfig);
      }
      if (authenticated) await refreshRemoteData();
      _mqtt.statusStream.listen(_handleMqttStatus);
      try {
        await _permissions.requestMobilePermissions();
      } catch (e) {
        debugPrint('Permissions initialization error: $e');
      }
    } catch (e) {
      authenticated = false;
      lastError = e.toString();
      debugPrint('App initialization error: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    await _run(() async {
      await _supabase.initialize();
      await _supabase.signIn(email, password);
      authenticated = _supabase.authenticated;
      if (!authenticated) throw StateError('No se pudo iniciar sesión.');
      await refreshRemoteData();
    });
  }

  Future<void> loginWithGoogle() async {
    await _run(() async {
      await _supabase.initialize();
      await _supabase.signInWithGoogle();
      authenticated = _supabase.authenticated;
      if (authenticated) await refreshRemoteData();
    });
  }

  Future<void> loginWithGithub() async {
    await _run(() async {
      await _supabase.initialize();
      await _supabase.signInWithGithub();
      authenticated = _supabase.authenticated;
      if (authenticated) await refreshRemoteData();
    });
  }

  Future<void> register(RegisterDataModel data) async {
    await _run(() async {
      await _supabase.initialize();
      await _supabase.signUp(data);
      authenticated = _supabase.authenticated;
      if (!authenticated) {
        throw StateError(
          'Usuario registrado. Revisa tu correo para confirmar la cuenta e inicia sesión.',
        );
      }
      await refreshRemoteData();
    });
  }

  Future<void> loginWithBiometrics() async {
    await _run(() async {
      final ok = await _camera.authenticate();
      if (!ok) {
        throw StateError('Autenticación biométrica cancelada o no disponible.');
      }
      authenticated = _supabase.authenticated;
      if (!authenticated) {
        throw StateError('Primero inicia sesión con Supabase.');
      }
    });
  }

  Future<void> logout() async {
    await _supabase.signOut();
    authenticated = false;
    profile = null;
    events.clear();
    section = AppSection.dashboard;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String phone,
  }) async {
    await _run(() async {
      await _supabase.updateProfile(
        fullName: fullName,
        username: username,
        phone: phone,
      );
      await refreshRemoteData();
    });
  }

  Future<void> uploadAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async {
    await _run(() async {
      final avatarUrl = await _supabase.uploadAvatarBytes(bytes, fileName);
      if (avatarUrl != null) {
        await _supabase.updateAvatarUrl(avatarUrl);
        await refreshRemoteData();
      }
    });
  }

  void setSection(AppSection next) {
    section = next;
    notifyListeners();
  }

  Future<void> sendLedCommand(bool turnOn) async {
    final previous = ledOn ? 'ON' : 'OFF';
    final startedAt = DateTime.now();
    messagesSent++;
    notifyListeners();
    await _mqtt.publishLedCommand(mqttConfig, turnOn);
    latencyMs = DateTime.now().difference(startedAt).inMilliseconds;
    ledOn = turnOn;
    stateSince = DateTime.now();
    final event = LedEventModel(
      action: turnOn ? 'ON' : 'OFF',
      previousState: previous,
      newState: turnOn ? 'ON' : 'OFF',
      createdAt: DateTime.now(),
      latencyMs: latencyMs,
      confirmed: _mqtt.connected || simulatorActive,
    );
    events.insert(0, event);
    await _supabase.insertLedEvent(event);
    await _upsertDeviceStatus();
    notifyListeners();
  }

  Future<void> sendColorCommand(String color) async {
    final previous = ledColor;
    final startedAt = DateTime.now();
    messagesSent++;
    notifyListeners();
    await _mqtt.publishColorCommand(mqttConfig, color);
    latencyMs = DateTime.now().difference(startedAt).inMilliseconds;
    ledColor = color;
    ledOn = color != 'off';
    if (ledOn) {
      stateSince = DateTime.now();
    }
    final event = LedEventModel(
      action: color == 'off' ? 'OFF' : 'COLOR',
      previousState: previous,
      newState: color,
      createdAt: DateTime.now(),
      latencyMs: latencyMs,
      confirmed: _mqtt.connected || simulatorActive,
      color: color,
    );
    events.insert(0, event);
    await _supabase.insertLedEvent(event);
    await _upsertDeviceStatus();
    notifyListeners();
  }

  Future<void> refreshRemoteData() async {
    profile = await _supabase.fetchProfile();
    final remoteEvents = await _supabase.fetchLedEvents();
    events
      ..clear()
      ..addAll(remoteEvents);
    final status = await _supabase.fetchDeviceStatus();
    if (status != null) {
      ledOn = status['led_state'] == 'ON';
      mqttConnected = status['online'] == true;
      simulatorActive = status['simulator_active'] == true;
      final uptime = status['uptime_seconds'];
      if (uptime is int && uptime > 0) {
        stateSince = DateTime.now().subtract(Duration(seconds: uptime));
      }
    }
  }

  Future<void> saveConfiguration() async {
    await _run(() async {
      await _localConfig.save(mqttConfig);
      await _supabase.initialize();
      await _supabase.saveMqttConfig(mqttConfig);
    });
  }

  Future<void> _syncRemoteMqttConfig() async {
    final remote = await _supabase.fetchMqttConfig();
    if (remote == null) return;

    mqttConfig
      ..configName = remote.configName
      ..brokerHost = remote.brokerHost
      ..brokerPort = remote.brokerPort
      ..websocketPort = remote.websocketPort
      ..useSsl = remote.useSsl
      ..topicControl = remote.topicControl
      ..topicStatus = remote.topicStatus
      ..topicColor = remote.topicColor
      ..topicHeartbeat = remote.topicHeartbeat
      ..qos = remote.qos
      ..retain = remote.retain
      ..keepAlive = remote.keepAlive
      ..clientId = remote.clientId
      ..username = remote.username
      ..password = remote.password;

    await _localConfig.save(mqttConfig);
  }

  Future<Map<String, dynamic>> testConnection() async {
    final startedAt = DateTime.now();
    final result = await _mqtt.testConnection(mqttConfig);

    if (result['success'] == true) {
      latencyMs = DateTime.now().difference(startedAt).inMilliseconds;
      mqttConnected = true;
    } else {
      mqttConnected = false;
    }

    return result;
  }

  Future<void> createSupportTicket({
    required String subject,
    required String category,
    required String priority,
    required String description,
  }) async {
    await _supabase.createSupportTicket(
      SupportTicketModel(
        subject: subject,
        category: category,
        priority: priority,
        description: description,
        createdAt: DateTime.now(),
      ),
    );
  }

  void toggleSimulator(bool value) {
    simulatorActive = value;
    _upsertDeviceStatus();
    notifyListeners();
  }

  Future<void> _upsertDeviceStatus() {
    final uptimeSeconds = DateTime.now().difference(stateSince).inSeconds;
    return _supabase.upsertDeviceStatus(
      ledOn: ledOn,
      online: mqttConnected,
      simulatorActive: simulatorActive,
      uptimeSeconds: uptimeSeconds,
    );
  }

  void toggleSidebar() {
    sidebarExpanded = !sidebarExpanded;
    notifyListeners();
  }

  void _handleMqttStatus(String payload) {
    if (payload == 'CONNECTED') {
      mqttConnected = true;
    } else if (payload == 'DISCONNECTED') {
      mqttConnected = false;
    } else if (payload == 'ON' || payload == 'OFF') {
      ledOn = payload == 'ON';
      messagesReceived++;
      stateSince = DateTime.now();
    }
    notifyListeners();
  }

  Future<void> _run(Future<void> Function() action) async {
    loading = true;
    lastError = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      lastError = error.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mqtt.dispose();
    super.dispose();
  }
}
