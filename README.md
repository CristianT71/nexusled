# NexusLED

NexusLED es una aplicación Flutter para controlar y monitorear un LED desde cualquier lugar usando MQTT como canal de mensajería y Supabase como backend de autenticación, base de datos y sincronización.

La aplicación está preparada para ejecutarse en Android, Windows, web y, en general, en cualquier plataforma soportada por Flutter. La versión web está publicada en Netlify y los binarios de Android y Windows se distribuyen desde GitHub Releases.

Sitio web:
https://nexusled.netlify.app/

## Qué hace el proyecto

NexusLED centraliza el control de un sistema IoT con estas funciones principales:

- iniciar sesión con Supabase usando correo y contraseña;
- iniciar sesión con Google;
- registrar usuarios nuevos;
- guardar y recuperar configuración MQTT;
- controlar un LED RGB con tres colores (RED, GREEN, BLUE);
- enviar comandos de color y apagado al LED;
- registrar eventos con color, latencia, confirmación y plataforma;
- mostrar estadísticas y estado del sistema en tiempo real;
- operar con simulador cuando no hay hardware conectado;
- persistir la configuración localmente para que no se pierda entre sesiones.

## Arquitectura general

La app tiene tres capas principales:

- Presentación: pantallas, tarjetas, widgets y navegación.
- Estado: `NexusLedState`, que concentra el flujo de datos y las acciones de la app.
- Datos y servicios: MQTT, Supabase, almacenamiento local, permisos y cámara.

El flujo normal es este:

1. La app inicia y carga `.env` si existe.
2. Se recupera la configuración local desde `SharedPreferences`.
3. Si hay datos de Supabase válidos, se inicializa el cliente.
4. Si el usuario ya tiene sesión activa, se sincroniza la configuración MQTT remota.
5. La interfaz principal se muestra con el estado del LED, eventos y conexión.

## Pantallas y funcionamiento

### Splash

La pantalla inicial muestra una bienvenida breve mientras la app termina de cargar configuración, sesión y estado.

### Login

Permite iniciar sesión con correo y contraseña o con Google. Desde aquí se entra al sistema cuando Supabase está configurado.

### Registro

Crea cuentas nuevas en Supabase con datos básicos del usuario.

### Dashboard

Es la vista principal. Muestra:

- estado actual del LED;
- latencia de respuesta;
- actividad reciente;
- tiempo en el estado actual;
- tarjetas de métricas;
- gráficos de actividad y rendimiento;
- acceso rápido a la pantalla de control.

También incluye un carrusel de resumen automático para mostrar información importante del sistema.

### Control LED

Es la pantalla operativa. Desde aquí se envían comandos MQTT para:

- encender el LED en color ROJO;
- encender el LED en color VERDE;
- encender el LED en color AZUL;
- apagar el LED.

Cada color tiene sus propios botones ON/OFF para control independiente.

Además muestra:

- si la conexión MQTT está activa;
- el broker y puerto actuales;
- el tópico de control;
- el tópico de color;
- el tiempo desde el último cambio;
- la latencia más reciente.

### Estadísticas

Resume los eventos del sistema con:

- total de eventos;
- promedio de latencia;
- distribución de colores RGB (RED, GREEN, BLUE, OFF);
- tabla con eventos recientes que incluye el color seleccionado.

### Información del sistema

Muestra detalles del entorno y del dispositivo:

- estado del LED;
- conexión MQTT;
- firmware reportado;
- mensajes enviados y recibidos;
- modo simulación;
- botón para forzar reconexión.

### Configuración MQTT y Supabase

Aquí se cargan y editan los datos más importantes del proyecto:

- nombre del perfil;
- host del broker MQTT;
- puerto MQTT;
- puerto WebSocket;
- tópico de control;
- tópico de estado;
- tópico de color;
- tópico de heartbeat;
- client ID;
- keep alive;
- usuario y contraseña MQTT;
- SSL/TLS;
- retained messages;
- Supabase Project URL;
- Supabase Anon Key;
- activación de Supabase.

Cuando se guarda:

- la configuración queda persistida en `SharedPreferences`;
- si hay sesión en Supabase, también se sincroniza la fila remota;
- la app intenta reutilizar la misma configuración, no crear una nueva en cada guardado.

### Perfil

Muestra el resumen de la cuenta activa:

- nombre completo;
- email;
- username;
- teléfono;
- proveedor de autenticación.

También permite cerrar sesión.

### Quiénes somos

Describe el propósito del proyecto, el enfoque IoT y las tecnologías usadas.

### Servicios

Resume las capacidades del sistema como control remoto, monitoreo, soporte multiplataforma, autenticación y registro histórico.

### Soporte y ayuda

Contiene preguntas frecuentes, solución de problemas y datos de contacto/documentación.

## Servicios de datos

### MQTT

La comunicación del LED se maneja con MQTT usando `mqtt_client`.

Funciones principales:

- publicar comandos de control;
- probar la conexión;
- registrar latencia;
- reaccionar a mensajes de estado;
- soportar conexión por TCP o WebSocket.

### Supabase

Supabase se usa para:

- autenticación;
- perfil de usuario;
- eventos LED;
- estado del dispositivo;
- tickets de soporte;
- configuración MQTT remota.

### Persistencia local

`SharedPreferences` guarda la configuración para que el usuario no tenga que volver a escribirla cada vez que abre la aplicación.

## Variables de entorno

La aplicación puede leer configuración de estas fuentes:

- `.env` para ejecución local;
- `dart-define` para builds web o CI/CD;
- `SharedPreferences` para persistencia local.

En Netlify se usa `dart-define` para inyectar estas variables:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

## Base de datos

El proyecto usa estas tablas en Supabase:

- `profiles`
- `mqtt_config`
- `led_events`
- `device_status`
- `support_tickets`
- `sessions`

La lógica actual intenta mantener una sola configuración MQTT activa por usuario y evitar duplicados.

## Requisitos

- Flutter SDK
- Dart compatible con el proyecto
- Android Studio o Visual Studio Code
- Supabase project
- Broker MQTT compatible, por ejemplo EMQX o Mosquitto

## Instalación local

```bash
flutter pub get
```

Si vas a usar configuración local, crea un archivo `.env` en la raíz del proyecto con tus valores de Supabase.

Ejemplo:

```env
SUPABASE_URL=tu-url-de-supabase
SUPABASE_ANON_KEY=tu-anon-key
```

## Ejecutar en desarrollo

```bash
flutter run
```

## Validar código

```bash
dart format lib test
flutter analyze
```

## Build de Android APK

```bash
flutter build apk --release
```

El APK generado normalmente queda en:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

## Build de Windows

```bash
flutter build windows --release
```

El ejecutable y los archivos necesarios quedan en:

```bash
build/windows/x64/runner/Release/
```

Si quieres compartirlo como archivo descargable, comprime toda esa carpeta en un ZIP antes de subirla a GitHub Releases.

## Despliegue web en Netlify

La versión web se compila con el script `scripts/netlify-build.sh`, que instala Flutter en el entorno de Netlify si hace falta y luego compila la app con `dart-define`.

El archivo de configuración es `netlify.toml`.

## Publicación en GitHub Releases

La distribución publicada del proyecto se maneja así:

- código fuente en GitHub;
- APK de Android como archivo adjunto en Releases;
- Windows como ZIP de la carpeta `Release` en Releases.

## Estructura del proyecto

- `lib/main.dart`: punto de entrada de la app.
- `lib/presentation/state/nexus_led_state.dart`: estado principal y coordinación entre servicios.
- `lib/data/services/`: servicios de MQTT, Supabase, permisos, cámara y almacenamiento local.
- `lib/presentation/screens/`: pantallas de la interfaz.
- `lib/presentation/widgets/`: componentes reutilizables.
- `esp32/nexusled_nano_esp32.ino`: firmware para Arduino IDE del Nano ESP32.
- `esp32/README.md`: guía corta del sketch MQTT y sus constantes.
- `supabase_schema.sql`: esquema de tablas y políticas de Supabase.
- `netlify.toml`: configuración de despliegue web.

## Flujo de uso recomendado

1. Configurar Supabase.
2. Registrar o iniciar sesión.
3. Guardar la configuración MQTT.
4. Probar la conexión.
5. Entrar a Control LED y enviar comandos.
6. Revisar Dashboard, Estadísticas e Información del sistema.

## Notas importantes

- La configuración guardada en la app persiste localmente.
- Si el usuario ya tiene sesión, la app intenta sincronizar la configuración MQTT con Supabase.
- El sitio web publicado está en Netlify.
- Los binarios de Android y Windows están en GitHub Releases.

## Próximos pasos posibles

- conectar el sketch del ESP32 con los tópicos definitivos;
- endurecer políticas de seguridad en Supabase;
- agregar más métricas históricas por color;
- mejorar la vista de soporte con documentación externa.
