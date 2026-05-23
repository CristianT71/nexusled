import 'package:shared_preferences/shared_preferences.dart';

import '../models/mqtt_config_model.dart';

class LocalConfigService {
  Future<void> load(MqttConfigModel mqtt) async {
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
    mqtt.topicColor = prefs.getString('mqtt.topicColor') ?? mqtt.topicColor;
    mqtt.topicHeartbeat = prefs.getString('mqtt.topicHeartbeat') ?? mqtt.topicHeartbeat;
    mqtt.qos = prefs.getInt('mqtt.qos') ?? mqtt.qos;
    mqtt.retain = prefs.getBool('mqtt.retain') ?? mqtt.retain;
    mqtt.keepAlive = prefs.getInt('mqtt.keepAlive') ?? mqtt.keepAlive;
    mqtt.clientId = prefs.getString('mqtt.clientId') ?? mqtt.clientId;
    mqtt.username = prefs.getString('mqtt.username') ?? mqtt.username;
    mqtt.password = prefs.getString('mqtt.password') ?? mqtt.password;
  }

  Future<void> save(MqttConfigModel mqtt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mqtt.configName', mqtt.configName);
    await prefs.setString('mqtt.brokerHost', mqtt.brokerHost);
    await prefs.setInt('mqtt.brokerPort', mqtt.brokerPort);
    await prefs.setInt('mqtt.websocketPort', mqtt.websocketPort);
    await prefs.setBool('mqtt.useSsl', mqtt.useSsl);
    await prefs.setString('mqtt.topicControl', mqtt.topicControl);
    await prefs.setString('mqtt.topicStatus', mqtt.topicStatus);
    await prefs.setString('mqtt.topicColor', mqtt.topicColor);
    await prefs.setString('mqtt.topicHeartbeat', mqtt.topicHeartbeat);
    await prefs.setInt('mqtt.qos', mqtt.qos);
    await prefs.setBool('mqtt.retain', mqtt.retain);
    await prefs.setInt('mqtt.keepAlive', mqtt.keepAlive);
    await prefs.setString('mqtt.clientId', mqtt.clientId);
    await prefs.setString('mqtt.username', mqtt.username);
    await prefs.setString('mqtt.password', mqtt.password);
  }
}
