import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient createMqttClient({
  required String brokerHost,
  required String websocketUrl,
  required String clientId,
  required int port,
}) {
  final client = MqttBrowserClient.withPort(websocketUrl, clientId, port);
  client.websocketProtocols = const ['mqtt'];
  return client;
}

void configureMqttClient(
  MqttClient client, {
  required int port,
  required bool secure,
}) {
  // Para Web, la configuración SSL y puerto se maneja en la URL WebSocket
  // Usamos MqttBrowserClient.withPort así que no se necesita más aquí.
}
