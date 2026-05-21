# MQTT Example

Here is an example of how to use MQTT (v3) with dart/flutter.

There are 2 projects:

- **smart_light_esp32** IoT "smart" light sketch for ESP32 boards.
- **light_controller** Flutter app using BLoC that controls the light, includes
	local protocol code and a Dart simulator of the smart light in `tool/`.

I have tested it on Mosquitto as MQTT broker and FireBeetle ESP32-E board.

![Flow of messages](./mqtt-light.drawio.svg)

## Server address

Check server address in `light_controller` connection form and
`smart_light.ino`.

- Set to `10.0.2.2` when running in Android Emulator

## Getting started

**Broker**

```sh
mosquitto -c mosquitto.conf
```

**Smart light ESP32**

[Instructions here](/smart_light_esp32/README.md)

**Smart light Dart**

```sh
cd light_controller
flutter pub run tool/smart_light_simulator.dart --host localhost --port 1883
```

**Light controller**

```sh
cd light_controller
flutter pub get
flutter run -d chrome
```

## Limitations

Only a single light is supported at a time.

Could be expanded with some sort of discovery of devices.
You could have a topic where devices (smart lights) can broadcast their
presence.
Then have a topic per device such that devices can be controlled individually.
