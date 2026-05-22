import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../models/mqtt_config_model.dart';
import 'mqtt_client_factory.dart';

class MqttService {
  MqttClient? _client;
  final _statusController = StreamController<String>.broadcast();

  Stream<String> get statusStream => _statusController.stream;
  bool get connected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  /// Detecta automáticamente el puerto WebSocket según el broker
  int _detectWebSocketPort(String brokerHost, int configuredPort) {
    // Si el usuario configuró un puerto WebSocket válido (no TCP), usarlo
    // Puertos TCP comunes: 1883, 8883. Ignorarlos para detección automática.
    final isTcpPort = configuredPort == 1883 || configuredPort == 8883;

    // Si el usuario configuró un puerto que no es TCP estándar, usarlo
    if (!isTcpPort &&
        configuredPort != 8080 &&
        configuredPort != 8083 &&
        configuredPort != 8084) {
      return configuredPort;
    }

    // Detección automática por broker
    final host = brokerHost.toLowerCase();
    if (host.contains('mosquitto')) {
      return 8080; // Mosquitto WebSocket
    } else if (host.contains('emqx') || host.contains('emqx.io')) {
      return 8084; // EMQX WebSocket (puerto estándar con SSL)
    } else if (host.contains('hivemq')) {
      return 8884; // HiveMQ WebSocket
    } else if (host.contains('mqtt') && host.contains('dashboard')) {
      return 8080; // Genérico para dashboards MQTT
    } else {
      return 8080; // Puerto WebSocket más común
    }
  }

  /// Detecta automáticamente el path WebSocket según el broker
  String _detectWebSocketPath(String brokerHost) {
    final host = brokerHost.toLowerCase();
    if (host.contains('emqx') || host.contains('emqx.io')) {
      return '/mqtt'; // EMQX usa /mqtt
    } else if (host.contains('hivemq')) {
      return '/mqtt'; // HiveMQ usa /mqtt
    } else if (host.contains('mosquitto')) {
      return '/ws'; // Mosquitto usa /ws o /mqtt
    } else {
      return '/mqtt'; // Path más común
    }
  }

  /// Detecta automáticamente si se debe usar SSL según el broker
  bool _detectSslRequirement(String brokerHost, bool userConfigured) {
    // Si el usuario ya configuró SSL explícitamente, respetarlo
    if (userConfigured) return true;

    final host = brokerHost.toLowerCase();
    // Brokers públicos que requieren SSL para WebSocket
    if (host.contains('hivemq') && host.contains('cloud')) {
      return true; // HiveMQ Cloud requiere SSL
    } else if (host.contains('aws') && host.contains('iot')) {
      return true; // AWS IoT requiere SSL
    } else if (host.contains('azure') && host.contains('devices')) {
      return true; // Azure IoT Hub requiere SSL
    }
    return false; // Por defecto no usar SSL
  }

  /// Construye la URL WebSocket completa para web
  String _buildWebSocketUrl(MqttConfigModel config) {
    final port = _detectWebSocketPort(config.brokerHost, config.websocketPort);
    final path = _detectWebSocketPath(config.brokerHost);
    final useSsl = config.useSsl;
    final protocol = useSsl ? 'wss' : 'ws';

    return '$protocol://${config.brokerHost}:$port$path';
  }

  /// Limpia el host para TCP (remueve ws://, wss://, http://, https://)
  String _cleanHostForTcp(String host) {
    String cleaned = host.trim();
    cleaned = cleaned.replaceFirst(RegExp(r'^ws://'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'^wss://'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'^http://'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'^https://'), '');
    return cleaned;
  }

  Future<void> connect(MqttConfigModel config) async {
    await disconnect();
    final clientId = config.clientId.trim().isEmpty
        ? 'nexusled_app_${DateTime.now().millisecondsSinceEpoch}'
        : config.clientId.trim();

    // Determinar puerto y URL antes de crear el cliente
    final wsPort = kIsWeb
        ? _detectWebSocketPort(config.brokerHost, config.websocketPort)
        : config.brokerPort;
    final websocketUrl = kIsWeb ? _buildWebSocketUrl(config) : '';
    final brokerHostArg = kIsWeb
        ? config.brokerHost
        : _cleanHostForTcp(config.brokerHost);

    final client = createMqttClient(
      brokerHost: brokerHostArg,
      websocketUrl: websocketUrl,
      clientId: clientId,
      port: wsPort,
    );

    // Configuración rápida: sin reintentos automáticos
    client.autoReconnect = false;
    client.setProtocolV311();
    client.logging(on: false);
    client.onDisconnected = () => _statusController.add('DISCONNECTED');
    client.onConnected = () => _statusController.add('CONNECTED');

    // Configurar puerto y SSL según plataforma (asegura settings para native)
    configureMqttClient(client, port: wsPort, secure: config.useSsl);

    // Preparar credenciales (si existen)
    final username = config.username.trim().isEmpty
        ? null
        : config.username.trim();
    final password = config.password.trim().isEmpty ? null : config.password;

    // Conectar directamente
    await client.connect(username, password);

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      throw StateError(
        'No se pudo conectar al broker MQTT: ${client.connectionStatus?.returnCode}',
      );
    }

    _client = client;
  }

  Future<void> publishLedCommand(MqttConfigModel config, bool turnOn) async {
    if (!connected) await connect(config);
    final builder = MqttClientPayloadBuilder()
      ..addString(turnOn ? 'ON' : 'OFF');
    _client?.publishMessage(
      config.topicControl,
      _qos(config.qos),
      builder.payload!,
      retain: config.retain,
    );
  }

  Future<void> publishColorCommand(MqttConfigModel config, String color) async {
    if (!connected) await connect(config);
    final builder = MqttClientPayloadBuilder()..addString(color);
    _client?.publishMessage(
      'nexusled/led/color',
      _qos(config.qos),
      builder.payload!,
      retain: config.retain,
    );
  }

  Future<void> disconnect() async {
    _client?.disconnect();
    _client = null;
  }

  MqttQos _qos(int qos) {
    return switch (qos) {
      0 => MqttQos.atMostOnce,
      2 => MqttQos.exactlyOnce,
      _ => MqttQos.atLeastOnce,
    };
  }

  /// Prueba de conexión universal para cualquier broker
  Future<Map<String, dynamic>> testConnection(MqttConfigModel config) async {
    final result = <String, dynamic>{
      'success': false,
      'details': <String, String>{},
    };

    try {
      // Detectar configuración automática
      final detectedPort = _detectWebSocketPort(
        config.brokerHost,
        config.websocketPort,
      );
      final detectedPath = _detectWebSocketPath(config.brokerHost);
      final detectedSsl = _detectSslRequirement(
        config.brokerHost,
        config.useSsl,
      );
      final wsUrl = _buildWebSocketUrl(config);

      result['details']['broker'] = config.brokerHost;
      result['details']['platform'] = kIsWeb
          ? 'Web (WebSocket)'
          : 'Mobile/Desktop (TCP)';
      result['details']['detected_port'] = detectedPort.toString();
      result['details']['detected_path'] = detectedPath;
      result['details']['detected_ssl'] = detectedSsl.toString();
      result['details']['websocket_url'] = wsUrl;

      // Intentar conexión
      await connect(config);
      result['success'] = true;
      result['details']['status'] = 'Conectado exitosamente';

      // Probar publicación
      await publishLedCommand(config, true);
      result['details']['publish_test'] = 'Mensaje ON publicado';

      await publishLedCommand(config, false);
      result['details']['publish_test'] = 'Mensaje OFF publicado';
    } catch (e) {
      result['success'] = false;
      result['details']['error'] = e.toString();

      // Sugerencias basadas en el error
      if (e.toString().contains('TIMED_OUT')) {
        result['details']['suggestion'] =
            'Verifica el host y puerto. Algunos brokers requieren puertos específicos para WebSocket.';
      } else if (e.toString().contains('REFUSED')) {
        result['details']['suggestion'] =
            'El puerto puede ser incorrecto. Intenta con 8080, 8083 o 8884 según el broker.';
      } else if (e.toString().contains('SSL')) {
        result['details']['suggestion'] =
            'Intenta habilitar/deshabilitar SSL según el broker.';
      } else if (e.toString().contains('auth')) {
        result['details']['suggestion'] =
            'Verifica usuario y contraseña. Algunos brokers públicos no requieren autenticación.';
      }
    }

    return result;
  }

  void dispose() {
    disconnect();
    _statusController.close();
  }
}
