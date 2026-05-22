import '../../core/constants/app_strings.dart';

class MqttConfigModel {
  MqttConfigModel({
    this.configName = 'Principal',
    this.brokerHost = AppStrings.defaultBroker,
    this.brokerPort = 1883,
    this.websocketPort = 8080,
    this.useSsl = false,
    this.topicControl = AppStrings.defaultControlTopic,
    this.topicStatus = AppStrings.defaultStatusTopic,
    this.topicColor = 'nexusled/led/color',
    this.topicHeartbeat = 'nexusled/heartbeat',
    this.qos = 1,
    this.retain = true,
    this.keepAlive = 60,
    this.clientId = 'nexusled_app_demo',
    this.username = '',
    this.password = '',
  });

  String configName;
  String brokerHost;
  int brokerPort;
  int websocketPort;
  bool useSsl;
  String topicControl;
  String topicStatus;
  String topicColor;
  String topicHeartbeat;
  int qos;
  bool retain;
  int keepAlive;
  String clientId;
  String username;
  String password;
}
