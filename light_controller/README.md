# light_controller

Controlador Flutter para una luz IoT usando MQTT, con soporte de broker
configurable (Mosquitto, EMQX, etc.) y simulador local del dispositivo.

## Uso desde una sola carpeta

Todos los comandos se ejecutan desde esta carpeta.

1. Instalar dependencias:

```sh
flutter pub get
```

2. Ejecutar app web:

```sh
flutter run -d chrome
```

3. Ejecutar simulador del dispositivo (en otra terminal):

```sh
flutter pub run tool/smart_light_simulator.dart --host localhost --port 1883
```

Ejemplo con broker remoto:

```sh
flutter pub run tool/smart_light_simulator.dart --host be185510.ala.us-east-1.emqxsl.com --port 1883 --username Nexus --password Nexus1234@
```

## Notas

- En web se utiliza WebSocket.
- En movil/escritorio puedes usar MQTT TCP o WebSocket desde la pantalla de
	conexion.
- La logica de protocolo esta dentro de `lib/protocol`.
