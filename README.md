# NexusLED

Aplicación Flutter para control remoto IoT de un LED usando una arquitectura preparada para MQTT, Supabase y despliegue web/mobile/desktop.

## Estado actual

- UI NexusLED con diseño glassmorphism morado/negro.
- Splash screen, login demo y layout principal responsivo.
- Sidebar desktop/tablet/mobile.
- Dashboard con tarjetas, actividad y eventos.
- Pantalla de Control LED por MQTT real con `mqtt_client`.
- Estadísticas, quiénes somos, servicios, información del sistema, configuración MQTT, soporte y perfil.
- Configuración MQTT y Supabase editable dentro de la app.
- Autenticación Supabase configurable desde la app.
- Biometría con `local_auth`.
- Permisos Android/iOS configurados.

## Ejecutar

```bash
flutter pub get
flutter run
```

## Validar

```bash
dart format lib test
flutter analyze
```

## Próximas integraciones

- Crear las tablas SQL del documento maestro en Supabase.
- Crear un usuario en Supabase Auth desde el panel o la app.
- Configurar el broker EMQX en la pantalla Configuración MQTT y Supabase.
- Crear el keystore Android local para builds release.

## Credenciales dentro de la app

Entra a `Configuración MQTT y Supabase` y llena:

- Broker MQTT, puertos, tópicos, QoS, retain, usuario y contraseña MQTT.
- Project URL y Anon Key de Supabase.
- Activa `Supabase Auth / Database`.
- Guarda configuración.
- Prueba conexión MQTT.

## Firma Android release

Por seguridad, el keystore y contraseñas no se guardan en Git. Crea `android/key.properties` localmente con:

```properties
storePassword=TU_PASSWORD
keyPassword=TU_PASSWORD
keyAlias=upload
storeFile=app/upload-keystore.jks
```

Luego genera tu keystore con `keytool` y ejecuta:

```bash
flutter build apk --release
```
