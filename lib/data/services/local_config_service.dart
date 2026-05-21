import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mqtt_config_model.dart';
import '../models/supabase_config_model.dart';

class LocalConfigService {
  Future<void> load(MqttConfigModel mqtt, SupabaseConfigModel supabase) async {
    final prefs = await SharedPreferences.getInstance();
    mqtt.configName = prefs.getString('mqtt.configName') ?? mqtt.configName;
    mqtt.brokerHost = prefs.getString('mqtt.brokerHost') ?? mqtt.brokerHost;
    mqtt.brokerPort = prefs.getInt('mqtt.brokerPort') ?? mqtt.brokerPort;
    mqtt.websocketPort =
        prefs.getInt('mqtt.websocketPort') ?? mqtt.websocketPort;
    mqtt.useSsl = prefs.getBool('mqtt.useSsl') ?? mqtt.useSsl;
    mqtt.topicControl =
        prefs.getString('mqtt.topicControl') ?? mqtt.topicControl;
    mqtt.topicStatus = prefs.getString('mqtt.topicStatus') ?? mqtt.topicStatus;
    mqtt.qos = prefs.getInt('mqtt.qos') ?? mqtt.qos;
    mqtt.retain = prefs.getBool('mqtt.retain') ?? mqtt.retain;
    mqtt.keepAlive = prefs.getInt('mqtt.keepAlive') ?? mqtt.keepAlive;
    mqtt.clientId = prefs.getString('mqtt.clientId') ?? mqtt.clientId;
    mqtt.username = prefs.getString('mqtt.username') ?? mqtt.username;
    mqtt.password = prefs.getString('mqtt.password') ?? mqtt.password;
    supabase.projectUrl =
        prefs.getString('supabase.projectUrl') ??
        _envValue('SUPABASE_URL') ??
        supabase.projectUrl;
    supabase.anonKey =
        prefs.getString('supabase.anonKey') ??
        _envValue('SUPABASE_ANON_KEY') ??
        supabase.anonKey;
    supabase.enabled = prefs.getBool('supabase.enabled') ?? supabase.enabled;
  }

  Future<void> save(MqttConfigModel mqtt, SupabaseConfigModel supabase) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mqtt.configName', mqtt.configName);
    await prefs.setString('mqtt.brokerHost', mqtt.brokerHost);
    await prefs.setInt('mqtt.brokerPort', mqtt.brokerPort);
    await prefs.setInt('mqtt.websocketPort', mqtt.websocketPort);
    await prefs.setBool('mqtt.useSsl', mqtt.useSsl);
    await prefs.setString('mqtt.topicControl', mqtt.topicControl);
    await prefs.setString('mqtt.topicStatus', mqtt.topicStatus);
    await prefs.setInt('mqtt.qos', mqtt.qos);
    await prefs.setBool('mqtt.retain', mqtt.retain);
    await prefs.setInt('mqtt.keepAlive', mqtt.keepAlive);
    await prefs.setString('mqtt.clientId', mqtt.clientId);
    await prefs.setString('mqtt.username', mqtt.username);
    await prefs.setString('mqtt.password', mqtt.password);
    await prefs.setString('supabase.projectUrl', supabase.projectUrl);
    await prefs.setString('supabase.anonKey', supabase.anonKey);
    await prefs.setBool('supabase.enabled', supabase.enabled);
  }

  String? _envValue(String key) {
    final dotenvValue = dotenv.env[key]?.trim();
    if (dotenvValue != null && dotenvValue.isNotEmpty) {
      return dotenvValue;
    }

    final defineValue = switch (key) {
      'SUPABASE_URL' => const String.fromEnvironment('SUPABASE_URL'),
      'SUPABASE_ANON_KEY' => const String.fromEnvironment('SUPABASE_ANON_KEY'),
      _ => '',
    }.trim();

    return defineValue.isEmpty ? null : defineValue;
  }
}
