import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient({
  required String brokerHost,
  required String websocketUrl,
  required String clientId,
  required int port,
}) {
  return MqttServerClient.withPort(brokerHost, clientId, port);
}

void configureMqttClient(
  MqttClient client, {
  required int port,
  required bool secure,
}) {
  if (client is MqttServerClient) {
    client.port = port;
    client.secure = secure;
    if (secure) {
      client.securityContext = SecurityContext.defaultContext;
    }
  }
}
