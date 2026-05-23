import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/led_event_model.dart';
import '../models/mqtt_config_model.dart';
import '../models/profile_model.dart';
import '../models/register_data_model.dart';
import '../models/supabase_config_model.dart';
import '../models/support_ticket_model.dart';

class SupabaseService {
  bool _initialized = false;

  bool get initialized => _initialized;
  SupabaseClient? get client => _initialized ? Supabase.instance.client : null;
  User? get currentUser => client?.auth.currentUser;
  bool get authenticated => currentUser != null;
  Stream<AuthState>? get authStateChanges => client?.auth.onAuthStateChange;

  Future<void> initialize() async {
    if (_initialized) return;
    
    // Try environment variables (for web/Netlify with --dart-define)
    String? url = const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    String? anonKey = const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
    
    // Fallback to dotenv (for APK/desktop with .env file)
    if (url.isEmpty || anonKey.isEmpty) {
      url = dotenv.env['SUPABASE_URL']?.trim();
      anonKey = dotenv.env['SUPABASE_ANON_KEY']?.trim();
    }
    
    if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
      _initialized = false;
      return;
    }
    
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    _initialized = true;
  }

  Future<void> signIn(String email, String password) async {
    final supabase = client;
    if (supabase == null) throw StateError('Supabase no está configurado.');
    await supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    final supabase = client;
    if (supabase == null) throw StateError('Supabase no está configurado.');
    final redirectUrl = kIsWeb
        ? 'https://nexusled.netlify.app/auth/callback'
        : 'io.supabase.nexusled://login-callback/';
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUrl,
    );
  }

  Future<void> signInWithGithub() async {
    final supabase = client;
    if (supabase == null) throw StateError('Supabase no está configurado.');
    final redirectUrl = kIsWeb
        ? 'https://nexusled.netlify.app/auth/callback'
        : 'io.supabase.nexusled://login-callback/';
    await supabase.auth.signInWithOAuth(
      OAuthProvider.github,
      redirectTo: redirectUrl,
    );
  }

  Future<void> signUp(RegisterDataModel data) async {
    final supabase = client;
    if (supabase == null) throw StateError('Supabase no está configurado.');
    final response = await supabase.auth.signUp(
      email: data.email.trim(),
      password: data.password,
      data: {
        'full_name': data.fullName.trim(),
        'username': data.username.trim(),
        'phone': data.phone.trim(),
        'auth_provider': 'email',
      },
    );
    final user = response.user;
    if (user != null) {
      await supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': data.fullName.trim(),
        'username': data.username.trim().isEmpty
            ? data.email.split('@').first
            : data.username.trim(),
        'phone': data.phone.trim(),
        'auth_provider': 'email',
      });
    }
  }

  Future<void> signOut() async {
    await client?.auth.signOut();
  }

  Future<ProfileModel?> fetchProfile() async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return null;
    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (data == null) return null;
    return ProfileModel.fromMap(data, email: user.email ?? '');
  }

  Future<void> updateProfile({
    required String fullName,
    required String username,
    required String phone,
  }) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return;
    await supabase.from('profiles').update({
      'full_name': fullName,
      'username': username,
      'phone': phone,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  Future<String?> uploadAvatar(String filePath) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return null;

    final file = File(filePath);
    final fileExt = filePath.split('.').last;
    final fileName = '${user.id}/avatar.$fileExt';

    await supabase.storage.from('avatars').upload(
      fileName,
      file,
    );

    final publicUrl = supabase.storage.from('avatars').getPublicUrl(fileName);
    return publicUrl;
  }

  Future<void> updateAvatarUrl(String avatarUrl) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return;
    await supabase.from('profiles').update({
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  Future<List<LedEventModel>> fetchLedEvents({int limit = 100}) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return [];
    final rows = await supabase
        .from('led_events')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map<LedEventModel>((row) {
      return LedEventModel(
        action: '${row['action'] ?? ''}',
        previousState: '${row['previous_state'] ?? 'UNKNOWN'}',
        newState: '${row['new_state'] ?? 'UNKNOWN'}',
        createdAt:
            DateTime.tryParse('${row['created_at'] ?? ''}') ?? DateTime.now(),
        latencyMs: row['response_time_ms'] is int
            ? row['response_time_ms'] as int
            : int.tryParse('${row['response_time_ms'] ?? 0}') ?? 0,
        confirmed: row['confirmed'] == true,
        platform: '${row['platform'] ?? 'flutter'}',
      );
    }).toList();
  }

  Future<Map<String, dynamic>?> fetchDeviceStatus() async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return null;
    return await supabase
        .from('device_status')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();
  }

  Future<void> upsertDeviceStatus({
    required bool ledOn,
    required bool online,
    required bool simulatorActive,
    required int uptimeSeconds,
  }) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return;
    await supabase.from('device_status').upsert({
      'user_id': user.id,
      'device_id': 'arduino-nano-esp32',
      'device_name': 'Arduino Nano ESP32',
      'led_state': ledOn ? 'ON' : 'OFF',
      'online': online,
      'simulator_active': simulatorActive,
      'uptime_seconds': uptimeSeconds,
      'last_seen_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> saveMqttConfig(MqttConfigModel config) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return;
    final data = {
      'user_id': user.id,
      'config_name': config.configName,
      'broker_host': config.brokerHost,
      'broker_port': config.brokerPort,
      'websocket_port': config.websocketPort,
      'use_ssl': config.useSsl,
      'topic_control': config.topicControl,
      'topic_status': config.topicStatus,
      'topic_color': config.topicColor,
      'topic_heartbeat': config.topicHeartbeat,
      'client_id': config.clientId,
      'username': config.username,
      'password': config.password,
      'qos': config.qos,
      'retain': config.retain,
      'keep_alive': config.keepAlive,
      'is_active': true,
    };

    final existing = await supabase
        .from('mqtt_config')
        .select('id')
        .eq('user_id', user.id)
        .order('updated_at', ascending: false);

    if (existing.isNotEmpty) {
      final id = existing.first['id'] as String;
      if (existing.length > 1) {
        await supabase
            .from('mqtt_config')
            .delete()
            .eq('user_id', user.id)
            .neq('id', id);
      }
      await supabase.from('mqtt_config').update(data).eq('id', id);
      return;
    }

    await supabase.from('mqtt_config').insert(data);
  }

  Future<MqttConfigModel?> fetchMqttConfig() async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return null;

    final rows = await supabase
        .from('mqtt_config')
        .select()
        .eq('user_id', user.id)
        .order('updated_at', ascending: false)
        .limit(1);

    if (rows.isEmpty) return null;

    final row = rows.first;
    return MqttConfigModel(
      configName: '${row['config_name'] ?? 'Principal'}',
      brokerHost: '${row['broker_host'] ?? ''}',
      brokerPort: row['broker_port'] is int
          ? row['broker_port'] as int
          : int.tryParse('${row['broker_port'] ?? 1883}') ?? 1883,
      websocketPort: row['websocket_port'] is int
          ? row['websocket_port'] as int
          : int.tryParse('${row['websocket_port'] ?? 8080}') ?? 8080,
      useSsl: row['use_ssl'] == true,
      topicControl: '${row['topic_control'] ?? ''}',
      topicStatus: '${row['topic_status'] ?? ''}',
      topicColor: '${row['topic_color'] ?? 'nexusled/led/color'}',
      topicHeartbeat: '${row['topic_heartbeat'] ?? 'nexusled/heartbeat'}',
      qos: row['qos'] is int ? row['qos'] as int : 1,
      retain: row['retain'] == true,
      keepAlive: row['keep_alive'] is int
          ? row['keep_alive'] as int
          : int.tryParse('${row['keep_alive'] ?? 60}') ?? 60,
      clientId: '${row['client_id'] ?? ''}',
      username: '${row['username'] ?? ''}',
      password: '${row['password'] ?? ''}',
    );
  }

  Future<void> insertLedEvent(LedEventModel event) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return;
    await supabase.from('led_events').insert({
      'user_id': user.id,
      'action': event.action,
      'previous_state': event.previousState,
      'new_state': event.newState,
      'source': event.source,
      'platform': event.platform,
      'response_time_ms': event.latencyMs,
      'confirmed': event.confirmed,
    });
  }

  Future<void> createSupportTicket(SupportTicketModel ticket) async {
    final supabase = client;
    final user = currentUser;
    if (supabase == null || user == null) return;
    await supabase.from('support_tickets').insert({
      'user_id': user.id,
      'subject': ticket.subject,
      'category': ticket.category,
      'priority': ticket.priority,
      'description': ticket.description,
    });
  }
}
