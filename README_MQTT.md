# MQTT en NexusLED

Este documento explica de forma simple cómo funciona MQTT dentro de NexusLED y para qué sirve cada parte.

## ¿Qué es MQTT?

MQTT significa Message Queuing Telemetry Transport. Es un protocolo ligero pensado para IoT.

Sirve para enviar mensajes entre dispositivos y aplicaciones con muy poco consumo de red.

En NexusLED se usa para mandar comandos al LED y recibir su estado.

## ¿Qué es el ESP32?

El ESP32 es el microcontrolador que recibe los mensajes MQTT desde el broker y ejecuta la acción física.

En este proyecto el ESP32 puede:

- encender el LED;
- apagar el LED;
- reportar su estado;
- enviar confirmaciones o eventos.

## ¿Qué es un broker MQTT?

El broker es el servidor central que recibe y distribuye los mensajes MQTT.

NexusLED no se comunica directo con el ESP32. Primero publica mensajes en el broker, y el ESP32 los recibe desde ahí.

Ejemplos de brokers:

- EMQX;
- Mosquitto;
- HiveMQ.

## ¿Qué es un tópico?

Un tópico es como una dirección o canal dentro de MQTT.

Se usa para organizar los mensajes. Por ejemplo:

- un tópico para comandos;
- un tópico para estado;
- un tópico para eventos;
- un tópico para latidos o heartbeat.

Si la app publica en un tópico, el ESP32 debe estar suscrito a ese mismo tópico para recibirlo.

## ¿Qué significa publicar y suscribirse?

### Publicar

Publicar es enviar un mensaje a un tópico.

En NexusLED la app publica comandos como:

- encender;
- apagar;
- alternar.

### Suscribirse

Suscribirse es decirle al broker: “quiero recibir todo lo que llegue a este tópico”.

En NexusLED el ESP32 se suscribe al tópico de control para escuchar los comandos.

## ¿Cómo se conecta NexusLED con MQTT?

El flujo normal es este:

1. El usuario abre NexusLED.
2. La app carga la configuración guardada.
3. NexusLED se conecta al broker MQTT usando host, puerto, usuario y contraseña.
4. La app publica el comando en el tópico de control.
5. El ESP32, que está suscrito a ese tópico, recibe el mensaje.
6. El ESP32 ejecuta la acción sobre el LED.
7. La app puede recibir un mensaje de confirmación o estado.

## ¿Qué configuración usa NexusLED?

En la pantalla de configuración MQTT y Supabase se guardan estos datos:

- nombre del perfil;
- host del broker;
- puerto MQTT;
- puerto WebSocket;
- tópico de control;
- tópico de estado;
- client ID;
- usuario MQTT;
- contraseña MQTT;
- SSL/TLS;
- retain;
- keep alive.

Esa configuración se guarda localmente para no tener que escribirla cada vez.

## ¿Qué es el puerto MQTT?

El puerto es el número que usa la app para conectarse al broker.

Los más comunes son:

- 1883: MQTT sin cifrado;
- 8883: MQTT con SSL/TLS.

## ¿Qué es el puerto WebSocket?

Es el puerto que permite usar MQTT a través de WebSocket, útil para navegadores y algunas plataformas web.

Los más comunes son:

- 8080: WebSocket sin cifrado;
- 8084 o similar: WebSocket con SSL/TLS.

En NexusLED se puede usar cuando la conexión web lo necesita.

## ¿Qué es SSL/TLS?

SSL/TLS es una capa de seguridad que cifra la comunicación.

Sirve para que los mensajes viajen protegidos entre la app y el broker.

Si está activado:

- se usa un puerto seguro;
- la conexión es más confiable para entornos de producción;
- los datos no viajan en texto plano.

## ¿Qué significa QoS?

QoS significa Quality of Service.

Define qué tan confiable debe ser el envío del mensaje.

Valores comunes:

- QoS 0: se envía una vez y ya;
- QoS 1: se garantiza al menos una entrega;
- QoS 2: entrega exactamente una vez, más pesado pero más seguro.

## ¿Qué significa retain?

Cuando un mensaje usa retain, el broker guarda el último valor publicado para ese tópico.

Así, cuando un dispositivo nuevo se suscribe, recibe el último estado sin esperar otro mensaje.

## ¿Qué es keep alive?

Es el tiempo que la app espera antes de considerar que la conexión está caída si no recibe respuesta.

Ayuda a mantener viva la sesión con el broker.

## Cómo se usa en NexusLED

Uso básico:

1. Abre la pantalla de configuración MQTT.
2. Escribe el broker, puertos y tópicos.
3. Guarda la configuración.
4. Prueba la conexión.
5. Ve a Control LED.
6. Envia encender, apagar o alternar.

## Resumen rápido

- MQTT es el protocolo de mensajería.
- El broker es el servidor que reparte mensajes.
- El ESP32 escucha los tópicos.
- NexusLED publica comandos.
- El ESP32 los recibe y controla el LED.
- SSL/TLS protege la conexión.
- Los puertos indican por dónde se conecta cada servicio.

## Nota final

Si cambias los tópicos en la app, deben coincidir exactamente con los del sketch del ESP32 y con la configuración del broker.
