# Sketch ESP32 para NexusLED

Este archivo es el código que puedes cargar en el Arduino IDE para el Nano ESP32.

## Qué hace

- conecta el ESP32 a WiFi;
- se conecta al broker MQTT;
- se suscribe al tópico de control `nexusled/led/control`;
- se suscribe al tópico de color `nexusled/led/color`;
- recibe comandos de control: `on`, `off`, `1`, `0`;
- recibe comandos de color: `red`, `green`, `blue`, `off`;
- controla un LED RGB con tres colores (ROJO, VERDE, AZUL);
- enciende el color seleccionado y apaga los demás;
- apaga todos los colores con el comando `off`;
- publica el estado en `nexusled/led/status`;
- publica un heartbeat en `nexusled/heartbeat` cada 60 segundos.

## Librerías necesarias

Instala estas librerías desde el Library Manager de Arduino IDE:

- PubSubClient
- WiFi

## Configuración que debes cambiar

Abre `nexusled_nano_esp32.ino` y modifica estas constantes:

- `WIFI_SSID`
- `WIFI_PASSWORD`
- `MQTT_BROKER`
- `MQTT_PORT`
- `MQTT_USER`
- `MQTT_PASSWORD`

## Tópicos usados por NexusLED

- Control: `nexusled/led/control`
- Color: `nexusled/led/color`
- Estado: `nexusled/led/status`
- Heartbeat: `nexusled/heartbeat`

## Cómo funciona con la app

1. La app publica un comando de color en el tópico de color.
2. El ESP32 lo recibe porque está suscrito a ese tópico.
3. El ESP32 enciende el color seleccionado y apaga los demás.
4. La app también puede publicar `on`, `off`, `1` o `0` en el tópico de control para controlar el LED integrado.
5. NexusLED puede usar esa información para monitoreo y sincronización.

## Pines del LED RGB

El sketch usa estos pines para el LED RGB:

- LED_PIN: LED_BUILTIN
- RED_PIN: D5
- GREEN_PIN: D7
- BLUE_PIN: D3

Cada pin RGB controla un color. En este sketch el RGB usa lógica directa:

- `RGB_ON = HIGH`
- `RGB_OFF = LOW`

Cuando se selecciona un color, ese pin se pone en `HIGH` y los demás en `LOW`.

**Nota:** Los pines RGB se ajustaron según la conexión física del hardware para que los colores coincidan con los comandos enviados desde la app.

## SSL/TLS

El sketch incluye una opción para usar SSL/TLS con `USE_SSL_TLS`.

- `0`: conexión normal por TCP, puerto típico `1883`.
- `1`: conexión segura TLS, puerto típico `8883`.

Si activas TLS, puedes dejar `setInsecure()` para pruebas rápidas o reemplazarlo por un certificado raíz en producción.

## Estado y heartbeat

El ESP32 publica:

- `ON` u `OFF` en `nexusled/led/status` cuando cambia el estado del LED integrado.
- `ONLINE` en `nexusled/heartbeat` al conectarse y luego cada 60 segundos.

El tópico de color no publica estado después de aplicar el color para evitar bucles infinitos de mensajes MQTT.

## Recomendación

Usa exactamente los mismos tópicos que configuraste en la app para que NexusLED y el ESP32 se entiendan sin cambios adicionales.
