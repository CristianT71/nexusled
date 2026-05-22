# Sketch ESP32 para NexusLED

Este archivo es el código que puedes cargar en el Arduino IDE para el Nano ESP32.

## Qué hace

- conecta el ESP32 a WiFi;
- se conecta al broker MQTT;
- se suscribe al tópico de control `nexusled/led/control`;
- recibe `ON`, `OFF` y `TOGGLE`;
- enciende o apaga el LED;
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
- Estado: `nexusled/led/status`
- Heartbeat: `nexusled/heartbeat`

## Cómo funciona con la app

1. La app publica un comando en el tópico de control.
2. El ESP32 lo recibe porque está suscrito a ese tópico.
3. El ESP32 cambia el estado del LED.
4. El ESP32 publica el nuevo estado en el tópico de estado.
5. NexusLED puede usar esa información para monitoreo y sincronización.

## SSL/TLS

El sketch incluye una opción para usar SSL/TLS con `USE_SSL_TLS`.

- `0`: conexión normal por TCP, puerto típico `1883`.
- `1`: conexión segura TLS, puerto típico `8883`.

Si activas TLS, puedes dejar `setInsecure()` para pruebas rápidas o reemplazarlo por un certificado raíz en producción.

## Recomendación

Usa exactamente los mismos tópicos que configuraste en la app para que NexusLED y el ESP32 se entiendan sin cambios adicionales.
