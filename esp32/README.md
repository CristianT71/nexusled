# Sketch ESP32 para NexusLED

Este archivo es el código que puedes cargar en el Arduino IDE para el Nano ESP32.

## Qué hace

- conecta el ESP32 a WiFi;
- se conecta al broker MQTT;
- se suscribe al tópico de control `nexusled/led/control`;
- se suscribe al tópico de color `nexusled/led/color`;
- recibe comandos de color: `red`, `green`, `blue`, `off`;
- controla un LED RGB con tres colores (ROJO, VERDE, AZUL);
- enciende el color seleccionado y apaga los demás;
- apaga todos los colores con el comando `off`;
- publica el estado en `nexusled/led/status`;
- publica un heartbeat en `nexusled/heartbeat`.

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
4. El ESP32 publica el nuevo estado en el tópico de estado.
5. NexusLED puede usar esa información para monitoreo y sincronización.

## Pines del LED RGB

El sketch usa estos pines para el LED RGB:

- RED_PIN: D3
- GREEN_PIN: D5
- BLUE_PIN: D7

Cada pin controla un color del LED RGB. Cuando se selecciona un color, ese pin se pone en HIGH y los demás en LOW.

## SSL/TLS

El sketch incluye una opción para usar SSL/TLS con `USE_SSL_TLS`.

- `0`: conexión normal por TCP, puerto típico `1883`.
- `1`: conexión segura TLS, puerto típico `8883`.

Si activas TLS, puedes dejar `setInsecure()` para pruebas rápidas o reemplazarlo por un certificado raíz en producción.

## Recomendación

Usa exactamente los mismos tópicos que configuraste en la app para que NexusLED y el ESP32 se entiendan sin cambios adicionales.
