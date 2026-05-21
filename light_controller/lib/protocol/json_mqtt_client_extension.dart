import 'dart:async';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';

extension JsonMqttClientExtension on MqttClient {
  Stream<JsonMessage<T>> jsonUpdates<T>({
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    return updates!.expand((updates) sync* {
      for (final update in updates) {
        final mqttMessage = update.payload as MqttPublishMessage;
        final topic = update.topic;
        final payload = MqttPublishPayload.bytesToStringAsString(
          mqttMessage.payload.message,
        );

        final json = jsonDecode(payload);
        final message = fromJson(json);

        yield (topic: topic, message: message);
      }
    });
  }

  int publishJsonMessage<T>(String topic, Map<String, dynamic> json) {
    final payload = jsonEncode(json);
    final builder = MqttClientPayloadBuilder()..addString(payload);
    return publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
}

typedef JsonMessage<T> = ({String topic, T message});
