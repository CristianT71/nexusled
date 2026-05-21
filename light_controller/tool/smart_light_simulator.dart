import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:light_controller/protocol/light_protocol.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const defaultServer = 'localhost';
const defaultPort = 1883;

String argValue(List<String> args, String key) {
  final index = args.indexOf(key);
  if (index < 0 || index + 1 >= args.length) {
    return '';
  }
  return args[index + 1];
}

void printUsage() {
  stdout.writeln('''
Smart Light Simulator

Usage:
  flutter pub run tool/smart_light_simulator.dart --host <host> --port <port> [--username <user>] [--password <pass>]

Examples:
  flutter pub run tool/smart_light_simulator.dart --host localhost --port 1883
  flutter pub run tool/smart_light_simulator.dart --host be185510.ala.us-east-1.emqxsl.com --port 1883 --username Nexus --password Nexus1234@
''');
}

Future<void> waitForEnter() {
  return stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .takeWhile((line) => line.isNotEmpty)
      .drain();
}

class LightBulb extends Device {
  Power _power;

  LightBulb({Power power = Power.off}) : _power = power;

  @override
  Power get power => _power;

  @override
  Future<void> turnOn() async {
    _power = Power.on;
    stdout.writeln('[LIGHT] ON');
  }

  @override
  Future<void> turnOff() async {
    _power = Power.off;
    stdout.writeln('[LIGHT] OFF');
  }
}

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--help') || arguments.contains('-h')) {
    printUsage();
    return;
  }

  final host = argValue(arguments, '--host');
  final portText = argValue(arguments, '--port');
  final username = argValue(arguments, '--username');
  final password = argValue(arguments, '--password');

  final server = host.isEmpty ? defaultServer : host;
  final port =
      int.tryParse(portText.isEmpty ? '$defaultPort' : portText) ?? defaultPort;

  stdout.writeln('Connecting simulator to $server:$port');

  final device = LightBulb();
  final mqttClient = MqttServerClient.withPort(server, 'smart-light-bulb', port)
    ..autoReconnect = true
    ..logging(on: true);

  await mqttClient.connect(
    username.isEmpty ? null : username,
    password.isEmpty ? null : password,
  );

  final protocol = DeviceProtocol(device: device, mqttClient: mqttClient);

  stdout.writeln('Simulator running. Press Enter to exit.');
  await waitForEnter();

  await protocol.dispose();
  mqttClient.disconnect();
}
