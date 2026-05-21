# ⚡ NexusLED — Documento Maestro de Planificación
> **Versión:** 1.0.0  
> **Fecha:** Mayo 2026  
> **Clasificación:** Documento interno de arquitectura y diseño completo  
> **Stack Principal:** Flutter · EMQX Cloud · Supabase · MQTT  

---

## 📋 TABLA DE CONTENIDO

1. [Visión General del Proyecto](#1-visión-general-del-proyecto)
2. [Nombre, Identidad y Branding](#2-nombre-identidad-y-branding)
3. [Arquitectura General del Sistema](#3-arquitectura-general-del-sistema)
4. [Stack Tecnológico Completo](#4-stack-tecnológico-completo)
5. [Protocolo MQTT — Explicación y Uso](#5-protocolo-mqtt--explicación-y-uso)
6. [Base de Datos — Supabase](#6-base-de-datos--supabase)
7. [Backend EMQX Cloud Broker](#7-backend-emqx-cloud-broker)
8. [Estructura de Carpetas del Proyecto Flutter](#8-estructura-de-carpetas-del-proyecto-flutter)
9. [Sistema de Diseño — Design System](#9-sistema-de-diseño--design-system)
10. [Pantallas y Flujos Completos](#10-pantallas-y-flujos-completos)
    - [Splash Screen](#101-splash-screen)
    - [Onboarding / Bienvenida](#102-onboarding--bienvenida)
    - [Login / Registro](#103-login--registro)
    - [Permisos (Mobile)](#104-permisos-mobile)
    - [Dashboard Principal](#105-dashboard-principal)
    - [Control del LED](#106-control-del-led)
    - [Gráficas y Estadísticas](#107-gráficas-y-estadísticas)
    - [Quiénes Somos](#108-quiénes-somos)
    - [Servicios](#109-servicios)
    - [Información del Sistema](#1010-información-del-sistema)
    - [Configuración de Conexión MQTT](#1011-configuración-de-conexión-mqtt)
    - [Soporte Técnico y Ayuda](#1012-soporte-técnico-y-ayuda)
    - [Perfil de Usuario](#1013-perfil-de-usuario)
11. [Menú Lateral (Sidebar)](#11-menú-lateral-sidebar)
12. [Navegación y Responsividad](#12-navegación-y-responsividad)
13. [Permisos de la App Móvil](#13-permisos-de-la-app-móvil)
14. [Autenticación con Cámara / Face ID](#14-autenticación-con-cámara--face-id)
15. [Política de Privacidad y Términos](#15-política-de-privacidad-y-términos)
16. [Simulación del LED sin Arduino](#16-simulación-del-led-sin-arduino)
17. [Flujo MQTT Publish/Subscribe](#17-flujo-mqtt-publishsubscribe)
18. [Despliegue — Netlify + GitHub](#18-despliegue--netlify--github)
19. [Animaciones y Efectos](#19-animaciones-y-efectos)
20. [Seguridad](#20-seguridad)
21. [Checklist Final de Entrega](#21-checklist-final-de-entrega)
22. [Glosario Técnico](#22-glosario-técnico)

---

## 1. Visión General del Proyecto

### ¿Qué es NexusLED?

**NexusLED** es una plataforma de control remoto IoT (Internet de las Cosas) que permite encender y apagar un LED conectado a un **Arduino Nano ESP32** desde cualquier lugar del mundo, usando únicamente una conexión a internet.

El usuario puede estar en Colombia, China, Japón o donde sea — si tiene internet y acceso a NexusLED, puede controlar el hardware físico en tiempo real.

### ¿Por qué es especial?

- Funciona en **web, móvil (Android/iOS) y escritorio (Windows/macOS/Linux)** desde un solo código base en Flutter.
- Usa **MQTT**, un protocolo ultraligero de mensajería IoT diseñado para dispositivos de baja potencia como Arduino.
- Tiene un **dashboard profesional** con estadísticas, historial de actividad, gráficas en tiempo real y tarjetas informativas.
- Diseño **glassmorphism** futurista con gradientes morado/negro — nada genérico, nada de Material Design estándar.
- Todo el control es **en tiempo real** gracias al protocolo Publish/Subscribe de MQTT.
- Base de datos **Supabase** para almacenar historial, usuarios y configuraciones.
- La conexión MQTT se configura **dentro de la app** (no en .env ni archivos externos) para que el usuario final pueda cambiarla sin tocar código.

### Problema que resuelve

Antes: Solo podías encender/apagar el LED si estabas físicamente frente al Arduino.  
Con NexusLED: Lo controlas desde cualquier lugar del planeta, en tiempo real, con estadísticas e historial.

### Audiencia objetivo

- Estudiantes de electrónica/IoT
- Desarrolladores que aprenden MQTT
- Personas que quieren controlar dispositivos remotamente
- El equipo de clase que necesita presentar un proyecto funcional

---

## 2. Nombre, Identidad y Branding

### Nombre: **NexusLED**

**¿Por qué NexusLED?**  
- **Nexus**: Del latín "conexión", "punto de unión". Representa la conexión entre el mundo digital y el físico.
- **LED**: Referencia directa al hardware controlado, pero también simboliza "luz" = claridad, tecnología, innovación.
- **Juntos**: Evoca un hub de control tecnológico, una plataforma que conecta personas con dispositivos.

### Tagline

> *"Control. Anywhere. Anytime."*  
> (Alternativa en español: *"Tu hardware, a la distancia de un toque."*)

### Paleta de Colores Principal

```
COLOR SYSTEM — NexusLED

Primarios:
  --nexus-purple-deep:     #1A0533   /* Fondo principal oscuro */
  --nexus-purple-mid:      #2D0A5E   /* Fondo de cards */
  --nexus-purple-accent:   #7B2FBE   /* Acento principal */
  --nexus-purple-bright:   #A855F7   /* Brillo / hover */
  --nexus-purple-glow:     #C084FC   /* Glow / shimmer */

Secundarios / Neón:
  --nexus-cyan-glow:       #06B6D4   /* Acento cyan para contrastes */
  --nexus-blue-electric:   #3B82F6   /* Azul eléctrico */
  --nexus-magenta:         #EC4899   /* Magenta para alertas vivas */

Fondos:
  --nexus-bg-primary:      #0A0015   /* Negro-morado profundo */
  --nexus-bg-secondary:    #110022   /* Cards de fondo */
  --nexus-bg-glass:        rgba(123, 47, 190, 0.08)  /* Glassmorphism base */
  --nexus-bg-glass-border: rgba(168, 85, 247, 0.25)  /* Bordes de vidrio */

Texto:
  --nexus-text-primary:    #F8F4FF   /* Blanco con tinte morado */
  --nexus-text-secondary:  #C4B5D4   /* Gris lavanda */
  --nexus-text-muted:      #7C6B8F   /* Texto deshabilitado */

Estado del LED:
  --led-on:                #22C55E   /* Verde brillante = LED encendido */
  --led-off:               #EF4444   /* Rojo = LED apagado */
  --led-connecting:        #F59E0B   /* Amarillo = conectando */
  --led-unknown:           #6B7280   /* Gris = estado desconocido */
```

### Gradientes Principales

```
Gradiente de fondo principal:
  linear-gradient(135deg, #0A0015 0%, #1A0533 50%, #0A0015 100%)

Gradiente de cards:
  linear-gradient(145deg, rgba(123,47,190,0.15) 0%, rgba(59,130,246,0.05) 100%)

Gradiente del botón de control:
  linear-gradient(135deg, #7B2FBE 0%, #A855F7 50%, #C084FC 100%)

Gradiente de header/topbar:
  linear-gradient(90deg, rgba(26,5,51,0.95) 0%, rgba(45,10,94,0.90) 100%)

Glow del LED encendido:
  box-shadow: 0 0 30px #22C55E, 0 0 60px rgba(34,197,94,0.4)

Glow del LED apagado:
  box-shadow: 0 0 30px #EF4444, 0 0 60px rgba(239,68,68,0.4)
```

### Logo

El logo de NexusLED consta de:
- **Ícono**: Una "N" estilizada formada por líneas de circuito que terminan en un punto de luz (LED) en la esquina superior derecha
- **Tipografía del logo**: `Exo 2` (bold/700) — fuente de estética tecnológica/scifi
- **Subtext**: "LED" en `Orbitron` (light/300) — futurista, espacial
- **Efecto**: El punto LED del ícono tiene animación de pulso suave (`glow pulse`)

### Tipografías

```
Display/Título principal:  Exo 2 (700, 600)         → Tecnológica, futurista
Subtítulos:                Rajdhani (600, 500)        → Geométrica, limpia
Body/Párrafos:             Nunito Sans (400, 300)     → Legible, suave
Monospace/Código:          JetBrains Mono (400)       → Para valores técnicos
Números grandes:           Orbitron (700)             → Muy futurista, para stats

Importar desde Google Fonts:
  'https://fonts.googleapis.com/css2?family=Exo+2:wght@300;400;600;700&family=Rajdhani:wght@400;500;600&family=Nunito+Sans:wght@300;400;600&family=Orbitron:wght@400;700&family=JetBrains+Mono&display=swap'
```

---

## 3. Arquitectura General del Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                        USUARIO FINAL                            │
│         (Celular / PC / Navegador Web — cualquier lugar)       │
└─────────────────┬───────────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                    APP FLUTTER — NexusLED                       │
│         Web (Netlify) · Android/iOS · Desktop (Win/Mac/Lin)    │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  Auth UI     │  │  Dashboard   │  │  Config MQTT (UI)    │  │
│  │  Login/Reg   │  │  Control LED │  │  Servidor/Puerto/    │  │
│  │  Camera Auth │  │  Stats/Graf  │  │  Tópico configurable │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘  │
│         │                 │                      │              │
└─────────┼─────────────────┼──────────────────────┼─────────────┘
          │                 │                      │
          ▼                 ▼                      ▼
┌──────────────────┐  ┌──────────────────────────────────────────┐
│   SUPABASE       │  │         EMQX CLOUD BROKER (MQTT)         │
│   (Base de Datos)│  │                                          │
│                  │  │  Servidor: broker.emqx.io                │
│  • usuarios      │  │  Puerto:   1883 (MQTT) / 8083 (WebSocket)│
│  • historial     │  │  Tópico:   nexusled/led/control          │
│  • config MQTT   │  │                                          │
│  • stats         │  │  PUBLISH ──────────────────► SUBSCRIBE   │
│  • logs          │  │  (App Flutter)              (Arduino ESP32│
│  • sesiones      │  │                              o Simulador) │
│                  │  │                                          │
└──────────────────┘  └──────────────────────────────────────────┘
                                      │
                                      ▼
                       ┌──────────────────────────┐
                       │   ARDUINO NANO ESP32      │
                       │                          │
                       │  • Conectado a WiFi       │
                       │  • Suscrito al tópico     │
                       │  • Recibe "ON" → LED 🟢   │
                       │  • Recibe "OFF" → LED 🔴  │
                       └──────────────────────────┘
```

### Flujo Completo de una Acción

```
1. Usuario abre NexusLED en su celular (Colombia)
2. Inicia sesión (autenticación con Supabase Auth)
3. Va al Dashboard → Control del LED
4. Presiona botón "ENCENDER"
5. App Flutter publica mensaje "ON" en tópico MQTT: nexusled/led/control
6. EMQX Cloud recibe el mensaje y lo distribuye
7. Arduino Nano ESP32 (suscrito al mismo tópico) recibe "ON"
8. Arduino ejecuta: digitalWrite(LED_PIN, HIGH)
9. LED físico se enciende 💡
10. Arduino publica de vuelta en: nexusled/led/status → "ON"
11. App Flutter (suscrita a nexusled/led/status) recibe confirmación
12. Dashboard actualiza el ícono del LED a VERDE con efecto glow
13. Supabase registra el evento en el historial con timestamp
14. La gráfica de actividad se actualiza en tiempo real
```

---

## 4. Stack Tecnológico Completo

### Frontend / App Principal

| Tecnología | Versión | Uso |
|-----------|---------|-----|
| **Flutter** | 3.x (latest stable) | Framework principal — Web, Mobile, Desktop |
| **Dart** | 3.x | Lenguaje de programación |
| **fl_chart** | ^0.68.0 | Gráficas y estadísticas |
| **mqtt_client** | ^10.x | Cliente MQTT para Flutter |
| **supabase_flutter** | ^2.x | SDK de Supabase |
| **provider** o **riverpod** | ^2.x | Gestión de estado |
| **go_router** | ^13.x | Navegación y rutas |
| **camera** | ^0.11.x | Cámara para auth facial |
| **permission_handler** | ^11.x | Manejo de permisos Android/iOS |
| **shared_preferences** | ^2.x | Almacenamiento local temporal |
| **lottie** | ^3.x | Animaciones Lottie (splash, efectos) |
| **glassmorphism** | ^3.x | Efectos de vidrio |
| **animated_text_kit** | ^4.x | Animaciones de texto |
| **shimmer** | ^3.x | Efecto shimmer en loading |
| **flutter_svg** | ^2.x | Iconos y logo SVG |
| **image_picker** | ^1.x | Selección de imágenes |
| **intl** | ^0.19.x | Formateo de fechas/números |
| **connectivity_plus** | ^6.x | Estado de conexión |
| **local_auth** | ^2.x | Biometría (huella/Face ID) |
| **carousel_slider** | ^5.x | Carrusel de tarjetas |
| **syncfusion_flutter_gauges** | ^26.x | Gauges para stats |
| **flutter_animate** | ^4.x | Animaciones fluidas |
| **google_fonts** | ^6.x | Tipografías de Google |

### Backend y Servicios en la Nube

| Servicio | Plan | Uso |
|---------|------|-----|
| **Supabase** | Free tier | Base de datos PostgreSQL, Auth, Storage |
| **EMQX Cloud** | Free tier (Serverless) | Broker MQTT en la nube |
| **Netlify** | Free tier | Despliegue de la versión Web |
| **GitHub** | Free | Control de versiones y CI/CD |

### Herramienta de Pruebas MQTT

| Herramienta | Uso |
|------------|-----|
| **MQTT Explorer** | Desktop — visualizar mensajes en tiempo real |
| **EMQX Cloud Dashboard** | Web — monitorear conexiones y mensajes |

---

## 5. Protocolo MQTT — Explicación y Uso

### ¿Qué es MQTT?

**MQTT** (Message Queuing Telemetry Transport) es un protocolo de mensajería ligero, diseñado específicamente para dispositivos IoT con recursos limitados (como Arduino).

Funciona bajo el patrón **Publicar/Suscribir** (Publish/Subscribe):

```
PUBLICADOR (Publisher)          BROKER                SUSCRIPTOR (Subscriber)
       │                          │                           │
       │── PUBLISH "ON" ─────────►│── distribuye "ON" ───────►│
       │   Tópico: led/control    │   a todos los             │
       │                          │   suscriptores            │
       │                          │   del tópico              │
```

### Analogía Simple

Piensa en MQTT como un sistema de radio:
- El **Broker** es la estación de radio (EMQX Cloud)
- El **Publisher** es quien habla al micrófono (App Flutter)
- El **Subscriber** es quien escucha con el radio (Arduino ESP32)
- El **Tópico** es la frecuencia de radio ("sintoniza el 98.5 FM")

Quien publica no necesita saber si hay alguien escuchando. Quien escucha no necesita saber quién habla. El broker en el medio lo coordina todo.

### Tópicos de NexusLED

```
ESTRUCTURA DE TÓPICOS:
nexusled/
├── led/
│   ├── control     → App publica "ON" o "OFF"
│   └── status      → Arduino publica el estado actual del LED
├── system/
│   ├── ping        → Para verificar si el Arduino está vivo
│   └── pong        → Arduino responde al ping
└── stats/
    └── uptime      → Arduino publica tiempo de funcionamiento
```

### Configuración del Broker en NexusLED

| Parámetro | Valor por defecto | Configurable |
|----------|-------------------|-------------|
| **Servidor** | `broker.emqx.io` | ✅ Sí, desde la app |
| **Puerto MQTT** | `1883` | ✅ Sí, desde la app |
| **Puerto WebSocket** | `8083` | ✅ Sí, desde la app |
| **Tópico Control** | `nexusled/led/control` | ✅ Sí, desde la app |
| **Tópico Status** | `nexusled/led/status` | ✅ Sí, desde la app |
| **Client ID** | `nexusled_app_{uuid}` | Auto-generado |
| **QoS** | `1` (At least once) | ✅ Sí, desde la app |
| **Retain** | `true` | ✅ Sí, desde la app |
| **Keep Alive** | `60 segundos` | Configurable |

> **IMPORTANTE**: Toda la configuración se guarda en Supabase (tabla `mqtt_config`) y también se cachea localmente con `shared_preferences`. No se usa ningún `.env` ni archivo de configuración externo.

### Código Arduino para el ESP32

```cpp
#include <WiFi.h>
#include <PubSubClient.h>

// ============================================
// CONFIGURACIÓN WiFi
// ============================================
const char* ssid = "TU_RED_WIFI";
const char* password = "TU_CONTRASEÑA";

// ============================================
// CONFIGURACIÓN MQTT
// ============================================
const char* mqtt_server = "broker.emqx.io";
const int mqtt_port = 1883;
const char* mqtt_client_id = "nexusled_arduino_esp32";
const char* topic_control = "nexusled/led/control";
const char* topic_status = "nexusled/led/status";

// ============================================
// PIN DEL LED
// ============================================
const int LED_PIN = 2; // Pin del LED integrado del ESP32

WiFiClient espClient;
PubSubClient client(espClient);

// ============================================
// CALLBACK — Se ejecuta cuando llega un mensaje
// ============================================
void callback(char* topic, byte* payload, unsigned int length) {
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  
  Serial.print("Mensaje recibido en tópico: ");
  Serial.print(topic);
  Serial.print(" → ");
  Serial.println(message);
  
  if (message == "ON") {
    digitalWrite(LED_PIN, HIGH);
    client.publish(topic_status, "ON", true); // Confirma estado
    Serial.println("LED ENCENDIDO ✓");
  } else if (message == "OFF") {
    digitalWrite(LED_PIN, LOW);
    client.publish(topic_status, "OFF", true); // Confirma estado
    Serial.println("LED APAGADO ✓");
  }
}

void setup_wifi() {
  WiFi.begin(ssid, password);
  Serial.print("Conectando a WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi conectado ✓ IP: " + WiFi.localIP().toString());
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Conectando a MQTT...");
    if (client.connect(mqtt_client_id)) {
      Serial.println("Conectado al broker EMQX ✓");
      client.subscribe(topic_control);
      client.publish(topic_status, "ONLINE", true);
    } else {
      Serial.print("Falló, rc=");
      Serial.print(client.state());
      Serial.println(" — Reintentando en 5s...");
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}
```

---

## 6. Base de Datos — Supabase

### ¿Por qué Supabase?

Supabase es una alternativa open-source a Firebase, construida sobre PostgreSQL. Ofrece:
- Autenticación de usuarios integrada
- Base de datos SQL en tiempo real
- Storage para archivos (fotos de perfil)
- Suscripciones en tiempo real (Realtime)
- Plan gratuito generoso

### Schema Completo de la Base de Datos

```sql
-- ============================================
-- TABLA: profiles
-- Información adicional de usuarios
-- ============================================
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  username TEXT UNIQUE,
  avatar_url TEXT,
  bio TEXT,
  role TEXT DEFAULT 'user' CHECK (role IN ('admin', 'user', 'viewer')),
  face_descriptor JSONB, -- Vector facial para auth por cámara
  face_auth_enabled BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- TABLA: mqtt_config
-- Configuración MQTT por usuario
-- ============================================
CREATE TABLE mqtt_config (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  config_name TEXT DEFAULT 'Principal',
  broker_host TEXT DEFAULT 'broker.emqx.io',
  broker_port INTEGER DEFAULT 1883,
  websocket_port INTEGER DEFAULT 8083,
  use_ssl BOOLEAN DEFAULT false,
  topic_control TEXT DEFAULT 'nexusled/led/control',
  topic_status TEXT DEFAULT 'nexusled/led/status',
  topic_ping TEXT DEFAULT 'nexusled/system/ping',
  client_id TEXT,
  username TEXT, -- Si el broker requiere auth
  password TEXT, -- Si el broker requiere auth
  qos INTEGER DEFAULT 1 CHECK (qos IN (0, 1, 2)),
  retain BOOLEAN DEFAULT true,
  keep_alive INTEGER DEFAULT 60,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- TABLA: led_events
-- Historial de acciones sobre el LED
-- ============================================
CREATE TABLE led_events (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  action TEXT NOT NULL CHECK (action IN ('ON', 'OFF', 'TOGGLE')),
  previous_state TEXT CHECK (previous_state IN ('ON', 'OFF', 'UNKNOWN')),
  new_state TEXT CHECK (new_state IN ('ON', 'OFF', 'UNKNOWN')),
  source TEXT DEFAULT 'app' CHECK (source IN ('app', 'schedule', 'api', 'voice')),
  platform TEXT, -- 'web', 'android', 'ios', 'windows', 'macos', 'linux'
  mqtt_topic TEXT,
  response_time_ms INTEGER, -- Latencia en ms
  confirmed BOOLEAN DEFAULT false, -- Si el Arduino confirmó
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- TABLA: device_status
-- Estado actual del dispositivo
-- ============================================
CREATE TABLE device_status (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  device_name TEXT DEFAULT 'Arduino Nano ESP32',
  led_state TEXT DEFAULT 'UNKNOWN' CHECK (led_state IN ('ON', 'OFF', 'UNKNOWN')),
  is_online BOOLEAN DEFAULT false,
  last_ping TIMESTAMPTZ,
  ip_address TEXT,
  firmware_version TEXT,
  uptime_seconds INTEGER DEFAULT 0,
  signal_strength INTEGER, -- RSSI WiFi
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- TABLA: support_tickets
-- Soporte técnico
-- ============================================
CREATE TABLE support_tickets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  subject TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT DEFAULT 'general' CHECK (category IN ('connection', 'bug', 'feature', 'general', 'hardware')),
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
  response TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- TABLA: sessions
-- Registro de sesiones de usuario
-- ============================================
CREATE TABLE sessions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  platform TEXT,
  device_info JSONB,
  ip_address TEXT,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  duration_seconds INTEGER
);

-- ============================================
-- FUNCIÓN: Auto-actualizar updated_at
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar triggers
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_mqtt_config_updated_at BEFORE UPDATE ON mqtt_config FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_device_status_updated_at BEFORE UPDATE ON device_status FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE mqtt_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE led_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;

-- Policies: solo el dueño puede ver/editar sus datos
CREATE POLICY "profiles_own" ON profiles FOR ALL USING (auth.uid() = id);
CREATE POLICY "mqtt_config_own" ON mqtt_config FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "led_events_own" ON led_events FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "support_own" ON support_tickets FOR ALL USING (auth.uid() = user_id);
```

---

## 7. Backend EMQX Cloud Broker

### ¿Por qué EMQX Cloud?

- Es uno de los brokers MQTT más populares del mundo
- Tiene plan gratuito (Serverless) perfectamente suficiente para este proyecto
- Soporta MQTT 3.1, 3.1.1 y 5.0
- Dashboard web para monitorear conexiones en tiempo real
- Soporte para WebSocket (necesario para la versión web de Flutter)

### Configuración en EMQX Cloud

```
1. Registrarse en: https://www.emqx.com/en/cloud
2. Crear un deployment tipo "Serverless"
3. Obtener las credenciales:
   - Endpoint: xxxx.ala.us-east-1.emqxsl.com
   - Puerto MQTT: 8883 (con TLS)
   - Puerto WebSocket: 8084 (con TLS)
4. Crear usuario MQTT en la consola
5. Configurar ACL (Access Control List) para el tópico nexusled/#
```

### Configuración alternativa (más simple para pruebas)

```
Broker público de EMQX (sin registro):
  Host: broker.emqx.io
  Puerto MQTT: 1883
  Puerto WebSocket: 8083
  (No requiere usuario/contraseña)
```

> ⚠️ **Para producción** usar el broker privado de EMQX Cloud con autenticación. Para pruebas/clase, el broker público es suficiente.

---

## 8. Estructura de Carpetas del Proyecto Flutter

```
nexusled/
│
├── 📁 lib/
│   ├── 📄 main.dart                    ← Entry point, inicialización
│   │
│   ├── 📁 core/
│   │   ├── 📁 constants/
│   │   │   ├── app_colors.dart         ← Paleta de colores completa
│   │   │   ├── app_typography.dart     ← Tipografías y estilos de texto
│   │   │   ├── app_spacing.dart        ← Espaciados, radios, tamaños
│   │   │   └── app_strings.dart        ← Textos y labels de la app
│   │   │
│   │   ├── 📁 theme/
│   │   │   ├── app_theme.dart          ← ThemeData principal
│   │   │   └── glass_theme.dart        ← Tema glassmorphism
│   │   │
│   │   ├── 📁 router/
│   │   │   └── app_router.dart         ← go_router configuración
│   │   │
│   │   └── 📁 utils/
│   │       ├── responsive_helper.dart  ← Breakpoints responsivos
│   │       ├── date_formatter.dart     ← Formateo de fechas
│   │       └── validators.dart         ← Validadores de formularios
│   │
│   ├── 📁 data/
│   │   ├── 📁 models/
│   │   │   ├── user_model.dart
│   │   │   ├── led_event_model.dart
│   │   │   ├── mqtt_config_model.dart
│   │   │   ├── device_status_model.dart
│   │   │   └── support_ticket_model.dart
│   │   │
│   │   ├── 📁 repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── led_repository.dart
│   │   │   ├── mqtt_config_repository.dart
│   │   │   └── support_repository.dart
│   │   │
│   │   └── 📁 services/
│   │       ├── mqtt_service.dart       ← Toda la lógica MQTT
│   │       ├── supabase_service.dart   ← Configuración Supabase
│   │       └── camera_service.dart     ← Servicio de cámara/auth facial
│   │
│   ├── 📁 presentation/
│   │   ├── 📁 providers/              ← Riverpod providers
│   │   │   ├── auth_provider.dart
│   │   │   ├── mqtt_provider.dart
│   │   │   ├── led_provider.dart
│   │   │   └── config_provider.dart
│   │   │
│   │   ├── 📁 screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── register_screen.dart
│   │   │   │   └── camera_auth_screen.dart
│   │   │   ├── main_shell.dart         ← Scaffold principal con sidebar
│   │   │   ├── dashboard/
│   │   │   │   └── dashboard_screen.dart
│   │   │   ├── led_control/
│   │   │   │   └── led_control_screen.dart
│   │   │   ├── statistics/
│   │   │   │   └── statistics_screen.dart
│   │   │   ├── about/
│   │   │   │   └── about_screen.dart
│   │   │   ├── services/
│   │   │   │   └── services_screen.dart
│   │   │   ├── system_info/
│   │   │   │   └── system_info_screen.dart
│   │   │   ├── settings/
│   │   │   │   └── settings_screen.dart
│   │   │   ├── support/
│   │   │   │   └── support_screen.dart
│   │   │   └── profile/
│   │   │       └── profile_screen.dart
│   │   │
│   │   └── 📁 widgets/
│   │       ├── 📁 common/
│   │       │   ├── glass_card.dart     ← Card glassmorphism reutilizable
│   │       │   ├── nexus_button.dart   ← Botón con gradiente
│   │       │   ├── nexus_text_field.dart
│   │       │   ├── loading_shimmer.dart
│   │       │   ├── glow_container.dart
│   │       │   └── nexus_snackbar.dart
│   │       │
│   │       ├── 📁 dashboard/
│   │       │   ├── stat_card.dart
│   │       │   ├── led_status_card.dart
│   │       │   ├── activity_chart.dart
│   │       │   ├── carousel_cards.dart
│   │       │   └── quick_actions.dart
│   │       │
│   │       ├── 📁 sidebar/
│   │       │   ├── sidebar_widget.dart
│   │       │   ├── sidebar_item.dart
│   │       │   └── user_profile_mini.dart
│   │       │
│   │       └── 📁 mqtt/
│   │           ├── connection_status_indicator.dart
│   │           └── mqtt_log_viewer.dart
│   │
├── 📁 assets/
│   ├── 📁 images/
│   │   ├── nexusled_logo.svg
│   │   ├── nexusled_logo_white.svg
│   │   └── splash_bg.png
│   ├── 📁 animations/
│   │   ├── splash_animation.json    ← Lottie animation
│   │   ├── led_on.json             ← Lottie LED encendido
│   │   └── connecting.json         ← Lottie conectando
│   └── 📁 fonts/
│       ├── Exo2/
│       ├── Rajdhani/
│       ├── NunitoSans/
│       └── Orbitron/
│
├── 📁 web/
│   └── index.html                  ← PWA config para web
│
├── 📁 android/
│   └── app/src/main/AndroidManifest.xml  ← Permisos Android
│
├── 📁 ios/
│   └── Runner/Info.plist           ← Permisos iOS
│
├── pubspec.yaml                    ← Dependencias Flutter
└── README.md
```

---

## 9. Sistema de Diseño — Design System

### Principio de Diseño: Glassmorphism Futurista

**Glassmorphism** es el efecto de "vidrio esmerilado" sobre fondos oscuros. Se caracteriza por:
- Fondo con `blur` (desenfoque gaussiano)
- Transparencia: `rgba` con opacidad baja (8–20%)
- Borde sutil luminoso: `border: 1px solid rgba(purple, 0.3)`
- Sombra interior y exterior con el color de acento

Además, NexusLED añade:
- **Glow neón**: Sombras de colores brillantes en los bordes y elementos activos
- **Gradientes animados**: Los fondos de secciones tienen animación sutil de gradiente
- **Partículas de fondo**: Puntos de luz pequeños que se mueven lentamente (como estrellas)
- **Scan lines**: Líneas horizontales sutilísimas en el fondo (efecto monitor retro-futurista)

### Componentes del Design System

#### GlassCard (componente base)

```dart
// Especificación del componente GlassCard
Container(
  decoration: BoxDecoration(
    color: Color(0x14A855F7), // rgba(168,85,247, 0.08)
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Color(0x40A855F7), // rgba(168,85,247, 0.25)
      width: 1.0,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x20A855F7),
        blurRadius: 20,
        spreadRadius: -5,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: /* contenido */,
    ),
  ),
)
```

#### Botón Primario (NexusButton)

```
Estado Normal:
  - Gradiente: linear-gradient(135deg, #7B2FBE → #A855F7)
  - Border radius: 12px
  - Padding: 16px × 32px
  - Sombra: 0 4px 20px rgba(168,85,247,0.4)
  - Texto: Exo 2, 600, 16px, blanco

Estado Hover (web/desktop):
  - Gradiente más brillante: #A855F7 → #C084FC
  - Sombra más intensa: 0 8px 30px rgba(168,85,247,0.6)
  - Scale: 1.02

Estado Loading:
  - Shimmer animado sobre el gradiente
  - CircularProgressIndicator pequeño, blanco

Estado Disabled:
  - Gradiente grisáceo: rgba(100,100,100,0.3)
  - Sin sombra
  - Opacidad: 0.5
```

#### TextField (NexusTextField)

```
Background: rgba(168,85,247,0.05) con blur
Border: 1px solid rgba(168,85,247,0.2) normal
       1px solid rgba(168,85,247,0.8) en focus
Border radius: 12px
Label: Rajdhani, 14px, color lavanda
Text: Nunito Sans, 16px, blanco
Icon: Morado claro, lado izquierdo
Error: Borde rojo con glow rgba(239,68,68,0.5)
```

#### LEDStatusBadge

```
Estado ON:
  - Círculo 16px diámetro
  - Color: #22C55E (verde)
  - Box shadow: 0 0 10px #22C55E, 0 0 20px rgba(34,197,94,0.5)
  - Animación: pulse (escala 1.0 → 1.3 → 1.0 cada 1.5s)
  - Texto al lado: "ENCENDIDO", Orbitron, 11px, verde

Estado OFF:
  - Mismo círculo
  - Color: #EF4444 (rojo)
  - Box shadow: 0 0 10px #EF4444
  - Sin animación de pulse
  - Texto: "APAGADO", Orbitron, 11px, rojo

Estado CONNECTING:
  - Color: #F59E0B (amarillo)
  - Animación: blink (opacidad 1.0 → 0.3, cada 0.8s)
  - Texto: "CONECTANDO...", Orbitron, 11px, amarillo
```

### Breakpoints de Responsividad

```dart
// responsive_helper.dart

class Breakpoints {
  static const double mobile = 600;    // < 600px → solo hamburguesa
  static const double tablet = 900;    // 600-900px → sidebar colapsado
  static const double desktop = 1200;  // > 900px → sidebar expandido
  static const double widescreen = 1600; // > 1600px → layout extra amplio
}

class ResponsiveHelper {
  static bool isMobile(BuildContext ctx) => 
    MediaQuery.of(ctx).size.width < Breakpoints.mobile;
  
  static bool isTablet(BuildContext ctx) => 
    MediaQuery.of(ctx).size.width >= Breakpoints.mobile &&
    MediaQuery.of(ctx).size.width < Breakpoints.desktop;
  
  static bool isDesktop(BuildContext ctx) => 
    MediaQuery.of(ctx).size.width >= Breakpoints.desktop;
  
  // Sidebar visible automáticamente en desktop
  static bool showSidebar(BuildContext ctx) => isDesktop(ctx);
}
```

---

## 10. Pantallas y Flujos Completos

### 10.1. Splash Screen

**Duración**: 4–5 segundos  
**Archivo**: `splash_screen.dart`

**Elementos visuales**:
- Fondo: El gradiente oscuro morado/negro con partículas animadas
- Centro: Logo NexusLED animado con Lottie
  - La "N" se dibuja con efecto de trazo (stroke animation)
  - Aparece el punto LED con efecto de encendido (flash verde)
  - Aparece el nombre "NexusLED" con efecto de tipeo (AnimatedTextKit)
  - Aparece el tagline "Control. Anywhere. Anytime." con fade
- Abajo: Barra de carga lineal (LinearProgressIndicator) con gradiente morado
- Esquina inferior: Versión de la app (v1.0.0)

**Lógica**:
```dart
// Durante el splash, se hacen en paralelo:
// 1. Esperar 4 segundos (animación)
// 2. Verificar si el usuario está logueado (Supabase Auth)
// 3. Cargar configuración MQTT guardada
// 4. Verificar conectividad

Future.wait([
  Future.delayed(Duration(seconds: 4)),
  supabase.auth.currentSession != null ? loadUserData() : Future.value(),
]);

// Luego navegar:
// - Si hay sesión → Dashboard
// - Si no hay sesión → Onboarding / Login
```

---

### 10.2. Onboarding / Bienvenida

**Aparece**: Solo la primera vez que se instala la app (se guarda flag en SharedPreferences)  
**Archivo**: `onboarding_screen.dart`

**Estructura**: 3 slides con PageView

**Slide 1 — "Bienvenido a NexusLED"**:
- Ilustración SVG: Planeta Tierra con ondas MQTT saliendo
- Título: "Control Global"
- Descripción: "Controla tu hardware desde cualquier lugar del mundo con un toque."

**Slide 2 — "Tiempo Real"**:
- Ilustración SVG: Rayo de energía entre celular y Arduino
- Título: "MQTT en Tiempo Real"
- Descripción: "Protocolo ultraligero diseñado para IoT. Latencia de milisegundos."

**Slide 3 — "Tu Dashboard"**:
- Ilustración SVG: Mini-mockup del dashboard
- Título: "Todo en un lugar"
- Descripción: "Estadísticas, historial, gráficas y control total de tu dispositivo."

**UI**:
- Fondo: Glassmorphism con gradiente animado
- Indicador de puntos (dots) abajo
- Botón "Siguiente" → botón primario NexusLED
- Último slide: "Comenzar" → va a Login

---

### 10.3. Login / Registro

**Archivo**: `login_screen.dart`, `register_screen.dart`

**Layout** (mismo para ambos):
- Fondo: gradiente oscuro con efecto de red de circuitos sutil (SVG pattern)
- Card central glassmorphism, ancho máximo 440px, centrada
- Logo NexusLED pequeño arriba de la card
- Título: "Bienvenido de vuelta" (Login) / "Únete a NexusLED" (Registro)

**Campos Login**:
- Email (NexusTextField con ícono de sobre)
- Contraseña (NexusTextField con ícono de candado, toggle mostrar/ocultar)
- Link "¿Olvidaste tu contraseña?"
- Botón "INICIAR SESIÓN" (NexusButton primario, ancho completo)
- Separador "— o —"
- Botón "Continuar con Google" (opcional, Supabase lo soporta)
- Botón "Autenticar con Cámara" → abre CameraAuthScreen
- Link "¿No tienes cuenta? Regístrate"

**Campos Registro**:
- Nombre completo
- Email
- Contraseña (con indicador de fortaleza)
- Confirmar contraseña
- Checkbox: "Acepto los términos y política de privacidad" (con link a las políticas)
- Botón "CREAR CUENTA"
- Link "¿Ya tienes cuenta? Inicia sesión"

**Validaciones**:
- Email: formato válido
- Contraseña: mínimo 8 caracteres, al menos 1 número, 1 mayúscula
- Nombres: mínimo 3 caracteres
- Feedback visual inmediato con bordes de color y mensajes de error animados

---

### 10.4. Permisos (Mobile)

**Archivo**: Usando `permission_handler`  
**Aparece**: Primera vez que se abre la app en Android/iOS

**Permisos solicitados** (con explicación en pantalla de diálogo custom):

| Permiso | ¿Para qué? | Obligatorio |
|--------|-----------|------------|
| **Cámara** | Autenticación facial del usuario | Recomendado |
| **Almacenamiento / Fotos** | Guardar foto de perfil | Opcional |
| **Internet** | Comunicación MQTT | Obligatorio (auto) |
| **Bluetooth** (futuro) | Conexión directa con Arduino | Opcional |
| **Notificaciones** | Alertas de cambio de estado del LED | Recomendado |

**UI del diálogo de permisos**:
```
┌─────────────────────────────────┐
│  🔒  NexusLED necesita acceso   │
│                                  │
│  📷  Cámara                      │
│     Para verificar tu identidad  │
│     de forma segura              │
│                                  │
│  🖼️  Almacenamiento               │
│     Para guardar tu foto de      │
│     perfil                       │
│                                  │
│  🔔  Notificaciones               │
│     Para alertarte cuando el     │
│     LED cambie de estado         │
│                                  │
│  [No ahora]    [Permitir todo]   │
└─────────────────────────────────┘
```

---

### 10.5. Dashboard Principal

**Archivo**: `dashboard_screen.dart`  
**Ruta**: `/dashboard`  
**Descripción**: Pantalla principal con resumen de todo el sistema

**Layout General**:
```
┌─────────────────────────────────────────────────────┐
│ TOPBAR                                              │
│ "Dashboard"           🔍  🔔  [Usuario Avatar]  ⊡  │
├─────────────────────────────────────────────────────┤
│                                                     │
│ CARRUSEL DE TARJETAS RESUMEN (horizontal scroll)   │
│ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────┐  │
│ │Estado LED│ │Eventos   │ │Tiempo    │ │Latencia│  │
│ │🟢 ON     │ │Hoy: 14   │ │uptime    │ │32ms    │  │
│ │          │ │          │ │2h 34m    │ │        │  │
│ └──────────┘ └──────────┘ └──────────┘ └────────┘  │
│                                                     │
│ GRÁFICA DE ACTIVIDAD (últimas 24h)                 │
│ ┌───────────────────────────────────────────────┐  │
│ │  Eventos LED por hora                         │  │
│ │  ▓▓▓░░░▓▓░░░░░▓▓▓▓░░▓░░░▓▓▓▓▓▓░░░░░░░░      │  │
│ │  0  2  4  6  8  10  12  14  16  18  20  22   │  │
│ └───────────────────────────────────────────────┘  │
│                                                     │
│ DOS COLUMNAS (en desktop) / UNA (en móvil)         │
│ ┌──────────────────┐  ┌──────────────────────────┐ │
│ │ CONTROL RÁPIDO   │  │ ÚLTIMOS EVENTOS           │ │
│ │ [ON] [OFF]       │  │ 14:32 → ON (tú)           │ │
│ │ Estado: 🟢 ON    │  │ 14:15 → OFF (tú)          │ │
│ │                  │  │ 13:50 → ON (tú)           │ │
│ └──────────────────┘  └──────────────────────────┘ │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Topbar (siempre visible)**:
- Título de la sección actual (izquierda)
- Ícono de búsqueda (que abre un modal de búsqueda con blur)
- Ícono de notificaciones con badge de cantidad
- Avatar del usuario (clickeable → va a Perfil)
- Botón minimizar/maximizar el sidebar (en desktop)

**Tarjetas del Carrusel** (CarouselSlider):

*Card 1 — Estado del LED*:
- Ícono grande de bulbo con glow verde/rojo según estado
- Texto grande: "ENCENDIDO" / "APAGADO"
- Animación pulse si está ON

*Card 2 — Actividad de Hoy*:
- Número grande (Orbitron): "14"
- Label: "eventos hoy"
- Mini gráfica de barras inline
- Comparativa: "↑ 3 más que ayer"

*Card 3 — Tiempo Activo*:
- Número: "2h 34m"
- Label: "dispositivo online"
- Barra de progreso circular

*Card 4 — Latencia MQTT*:
- Número: "32ms"
- Label: "latencia promedio"
- Indicador semáforo: verde < 100ms, amarillo < 500ms, rojo > 500ms

**Gráfica de Actividad**:
- Tipo: Área / Line Chart (fl_chart)
- Datos: cantidad de eventos por hora, últimas 24 horas
- Colores: línea morado brillante, área con gradiente morado transparente
- Interactivo: al hacer tap/hover en un punto, muestra tooltip con detalles
- Eje X: horas del día
- Eje Y: número de eventos

---

### 10.6. Control del LED

**Archivo**: `led_control_screen.dart`  
**Ruta**: `/control`  
**Descripción**: Pantalla principal de control del LED

**Layout**:
```
┌─────────────────────────────────────────────┐
│ TOPBAR: "Control LED"                       │
├─────────────────────────────────────────────┤
│                                             │
│  ESTADO DE CONEXIÓN MQTT                    │
│  ● Conectado a broker.emqx.io              │
│  Tópico: nexusled/led/control               │
│                                             │
│  ┌─────────────────────────────────────┐   │
│  │                                     │   │
│  │     VISUALIZACIÓN DEL LED           │   │
│  │                                     │   │
│  │         🔆  (grande, con glow)     │   │
│  │                                     │   │
│  │    Estado: ● ENCENDIDO              │   │
│  │    Desde hace: 00:14:32             │   │
│  │    Último comando: Tú, 14:32:01     │   │
│  │                                     │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌──────────────┐    ┌──────────────┐      │
│  │   ENCENDER   │    │    APAGAR    │      │
│  │   [ON ⚡]    │    │   [OFF ○]    │      │
│  └──────────────┘    └──────────────┘      │
│                                             │
│  — o —                                     │
│                                             │
│  [ALTERNAR] (toggle ON/OFF)                 │
│                                             │
│  INFORMACIÓN DEL ÚLTIMO EVENTO             │
│  Acción: ON                                 │
│  Hora: 14:32:01                             │
│  Latencia: 28ms                             │
│  Confirmado por Arduino: ✓                  │
│                                             │
└─────────────────────────────────────────────┘
```

**Visualización del LED**:
- Widget central grande (250×250px en desktop, 180×180px en móvil)
- LED ON: círculo con gradiente verde brillante + glow animado pulsante
- LED OFF: círculo gris oscuro + glow rojo suave
- Transición animada entre estados (300ms, curva easeInOut)
- Contador de tiempo que lleva en ese estado

**Botones de Control**:
- Botón ON: gradiente verde, ícono de rayo ⚡
- Botón OFF: gradiente rojo/gris, ícono de círculo con línea
- Ambos deshabilitados durante 500ms después de presionar (evitar doble click)
- Feedback táctil (vibración en móvil)
- Durante la espera de confirmación: efecto shimmer sobre el botón presionado

**Flujo al presionar "ENCENDER"**:
1. Botón muestra loading state
2. Se publica `ON` en `nexusled/led/control` vía MQTT
3. Se espera mensaje en `nexusled/led/status`
4. Si llega confirmación `ON` → actualizar UI, quitar loading, mostrar snackbar éxito
5. Si en 5 segundos no llega confirmación → snackbar de advertencia "Sin confirmación del dispositivo"
6. En ambos casos, registrar el evento en Supabase (tabla `led_events`)

---

### 10.7. Gráficas y Estadísticas

**Archivo**: `statistics_screen.dart`  
**Ruta**: `/statistics`

**Secciones de la pantalla**:

**1. Gráfica de Actividad Diaria** (Line Chart):
- Eje X: horas (0-23)
- Eje Y: número de eventos
- Filtros: Hoy / Esta semana / Este mes
- Leyenda: ON (verde) / OFF (rojo)

**2. Gráfica de Distribución** (Pie/Donut Chart):
- Proporción de tiempo que el LED estuvo ON vs OFF
- Centro del donut: porcentaje principal
- Leyenda debajo

**3. Gráfica de Latencia** (Bar Chart):
- Latencia promedio por hora del día
- Color condicional: verde/amarillo/rojo según valor
- Promedio general como línea horizontal

**4. Tabla de Eventos Recientes**:
- Columnas: Fecha/Hora, Acción, Usuario, Plataforma, Latencia, Confirmado
- Paginación (10 por página)
- Filtros por acción (ON/OFF) y fecha
- Export a CSV (botón)

**5. Métricas de Resumen**:
```
┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐
│ Total      │ │ Promedio   │ │ Máx/Día    │ │ Uptime     │
│ Eventos    │ │ Latencia   │ │ Eventos    │ │ Dispositivo│
│   342      │ │   45ms     │ │    28      │ │   98.3%    │
└────────────┘ └────────────┘ └────────────┘ └────────────┘
```

---

### 10.8. Quiénes Somos

**Archivo**: `about_screen.dart`  
**Ruta**: `/about`

**Contenido**:

**Hero Section**:
- Fondo con gradiente y partículas
- Logo NexusLED grande
- Tagline animado

**Misión**:
```
"NexusLED nace de la necesidad de conectar el mundo físico 
con el digital de manera simple, segura y accesible. 
Creemos que el IoT debe estar al alcance de todos."
```

**El Equipo**:
- Cards con foto (placeholder glassmorphism si no hay foto), nombre, rol
- Un card por integrante del grupo
- Ícono de LinkedIn/GitHub si aplica

**Historia del Proyecto**:
- Timeline visual con los hitos del proyecto:
  - 📅 Semana 1: Presentación del Arduino
  - 📅 Semana 2: Conexión del LED y resistencia
  - 📅 Semana 3: Código C++ en Arduino IDE
  - 📅 Semana 4: NexusLED — control desde la nube

**Tecnologías usadas**:
- Grid de logos: Flutter, EMQX, Supabase, GitHub, Netlify, MQTT

---

### 10.9. Servicios

**Archivo**: `services_screen.dart`  
**Ruta**: `/services`

**Contenido** (Cards glassmorphism en grid):

**Card 1 — Control Remoto**:
- Ícono: 📡 
- Título: "Control Global"
- Descripción: Controla tu dispositivo desde cualquier lugar con latencia mínima

**Card 2 — Monitoreo 24/7**:
- Ícono: 📊
- Título: "Monitoreo Continuo"
- Descripción: Estadísticas en tiempo real de tu dispositivo IoT

**Card 3 — Multi-plataforma**:
- Ícono: 💻📱🖥️
- Título: "Cualquier Dispositivo"
- Descripción: Web, Android, iOS, Windows, macOS, Linux — un solo código

**Card 4 — Seguridad**:
- Ícono: 🔒
- Título: "Autenticación Avanzada"
- Descripción: Login seguro con Supabase Auth y verificación por cámara

**Card 5 — Protocolo MQTT**:
- Ícono: ⚡
- Título: "MQTT Ultraligero"
- Descripción: El protocolo estándar de la industria IoT, optimizado para velocidad

**Card 6 — Historial**:
- Ícono: 📋
- Título: "Historial Completo"
- Descripción: Cada acción registrada con timestamp, latencia y confirmación

---

### 10.10. Información del Sistema

**Archivo**: `system_info_screen.dart`  
**Ruta**: `/system-info`

**Secciones**:

**Estado del Dispositivo (Arduino)**:
```
┌──────────────────────────────────────────┐
│ 🔌 Arduino Nano ESP32                    │
│ Estado: ● En línea                       │
│ IP: 192.168.1.105                        │
│ Señal WiFi: -65 dBm (████░░)            │
│ Uptime: 2h 34m 12s                       │
│ Firmware: v1.0.0                         │
│ Último ping: hace 5 segundos             │
└──────────────────────────────────────────┘
```

**Estado de la Conexión MQTT**:
```
┌──────────────────────────────────────────┐
│ 📡 Conexión MQTT                        │
│ Broker: broker.emqx.io                  │
│ Puerto: 1883                             │
│ Estado: ● Conectado                      │
│ Client ID: nexusled_app_a4f2b...        │
│ Latencia: 28ms                           │
│ Mensajes enviados: 342                   │
│ Mensajes recibidos: 342                  │
│ Reconexiones: 0                          │
└──────────────────────────────────────────┘
```

**Estado de Supabase**:
```
┌──────────────────────────────────────────┐
│ 🗄️ Base de Datos Supabase               │
│ Estado: ● Conectado                      │
│ Proyecto: nexusled-prod                  │
│ Registros LED Events: 342                │
│ Última sincronización: hace 2s           │
└──────────────────────────────────────────┘
```

**Información de la App**:
```
Versión: 1.0.0
Build: 2026.05.001
Plataforma: Android 14 / Web Chrome 124
Resolución: 1920 × 1080
Modo: Oscuro
```

**Botón "Forzar Reconexión MQTT"** — para casos de pérdida de conexión  
**Botón "Limpiar caché local"** — elimina configuración guardada

---

### 10.11. Configuración de Conexión MQTT

**Archivo**: `settings_screen.dart`  
**Ruta**: `/settings`

**Esta es una pantalla CRÍTICA del proyecto — toda la configuración MQTT vive aquí, dentro de la app, sin archivos externos.**

**Sección: Configuración HTTP / Conexión MQTT**:

```
┌─────────────────────────────────────────────────────┐
│ ⚙️  Configuración de Conexión MQTT                   │
│                                                      │
│  Nombre del perfil de conexión                       │
│  [Principal                    ]                     │
│                                                      │
│  🖥️  Servidor (Broker MQTT)                         │
│  [broker.emqx.io               ]                     │
│                                                      │
│  🔌  Puerto MQTT                                     │
│  [1883                         ]                     │
│                                                      │
│  🌐  Puerto WebSocket (para versión Web)             │
│  [8083                         ]                     │
│                                                      │
│  🔒  Usar SSL/TLS                                    │
│  ○ No   ● Sí                                         │
│                                                      │
│  📨  Tópico de Control                               │
│  [nexusled/led/control         ]                     │
│                                                      │
│  📩  Tópico de Estado                                │
│  [nexusled/led/status          ]                     │
│                                                      │
│  ┌─────────────────────────────────────────────┐    │
│  │  ▼  Opciones Avanzadas (expandible)         │    │
│  │                                             │    │
│  │  QoS (Quality of Service)                   │    │
│  │  ○ 0 - At most once                         │    │
│  │  ● 1 - At least once (recomendado)          │    │
│  │  ○ 2 - Exactly once                         │    │
│  │                                             │    │
│  │  Client ID (auto-generado si vacío)         │    │
│  │  [nexusled_app_                ]            │    │
│  │                                             │    │
│  │  Keep Alive (segundos)                      │    │
│  │  [60                          ]             │    │
│  │                                             │    │
│  │  Retained Messages                          │    │
│  │  ● Sí   ○ No                               │    │
│  │                                             │    │
│  │  Credenciales (si el broker las requiere)   │    │
│  │  Usuario: [                   ]             │    │
│  │  Contraseña: [                ]             │    │
│  └─────────────────────────────────────────────┘    │
│                                                      │
│  [PROBAR CONEXIÓN]    [GUARDAR CONFIGURACIÓN]        │
│                                                      │
│  ✓ Configuración guardada a las 14:32               │
└─────────────────────────────────────────────────────┘
```

**Botón "PROBAR CONEXIÓN"**:
1. Intenta conectar con los parámetros actuales
2. Muestra indicador de carga con texto "Conectando..."
3. Si éxito: snackbar verde "✓ Conexión exitosa — Latencia: 28ms"
4. Si falla: snackbar rojo con el error específico

**Sección: Notificaciones**:
- Toggle: Notificar cuando el LED cambie de estado
- Toggle: Notificar cuando el Arduino se desconecte
- Toggle: Notificar cuando haya error de conexión MQTT

**Sección: Preferencias de la App**:
- Toggle: Tema oscuro / claro (actualmente solo oscuro soportado)
- Toggle: Animaciones reducidas (accesibilidad)
- Selector de idioma: Español / English

**Sección: Cuenta**:
- Botón "Cambiar contraseña"
- Botón "Exportar mis datos"
- Botón rojo "Cerrar sesión"
- Botón rojo oscuro "Eliminar cuenta"

---

### 10.12. Soporte Técnico y Ayuda

**Archivo**: `support_screen.dart`  
**Ruta**: `/support`

**Subsecciones** (tabs o accordion):

**Tab 1 — Preguntas Frecuentes (FAQ)**:

*¿Por qué el LED no responde?*
→ Verifica que el Arduino esté encendido y conectado a WiFi. Revisa la configuración MQTT.

*¿Puedo controlar múltiples dispositivos?*
→ Actualmente NexusLED soporta un dispositivo por cuenta.

*¿Qué pasa si pierdo la conexión a internet?*
→ Los comandos enviados sin conexión se encolarán y ejecutarán al reconectar (QoS 1).

*¿Es seguro?*
→ Toda la autenticación pasa por Supabase con tokens JWT. La comunicación MQTT puede usar TLS.

**Tab 2 — Crear Ticket de Soporte**:

```
┌──────────────────────────────────────────┐
│  📩  Enviar solicitud de soporte         │
│                                           │
│  Asunto:                                  │
│  [                              ]        │
│                                           │
│  Categoría:                               │
│  [Conexión MQTT          ▼]              │
│                                           │
│  Prioridad:                               │
│  ○ Baja  ● Media  ○ Alta  ○ Crítica      │
│                                           │
│  Descripción detallada:                   │
│  ┌─────────────────────────────────────┐  │
│  │                                     │  │
│  │                                     │  │
│  └─────────────────────────────────────┘  │
│                                           │
│  [ENVIAR TICKET]                          │
└──────────────────────────────────────────┘
```

**Tab 3 — Mis Tickets**:
- Lista de tickets creados con estado (Abierto/En proceso/Resuelto)
- Al hacer click, ver conversación

**Tab 4 — Documentación**:
- Link a la documentación de MQTT
- Link al repositorio de GitHub
- Link al código del Arduino
- Guía de inicio rápido (formato markdown renderizado)

---

### 10.13. Perfil de Usuario

**Archivo**: `profile_screen.dart`  
**Ruta**: `/profile`

**Layout**:
- Header con foto de perfil circular (con efecto glassmorphism en el borde)
  - Botón de editar foto (abre image_picker)
  - Ícono de cámara para activar auth facial
- Nombre completo (editable)
- Username (editable, con verificación de unicidad)
- Email (no editable directamente, requiere proceso especial)
- Bio (editable, max 200 caracteres)

**Sección "Seguridad"**:
- Estado auth facial: Habilitado/Deshabilitado (toggle)
- Botón: "Actualizar datos faciales"
- Sesiones activas: lista de dispositivos donde está logueado

**Sección "Estadísticas personales"**:
- Total de acciones realizadas: 342
- Dispositivo más usado: Android
- Primera conexión: Fecha
- Último acceso: Hace 5 minutos

---

## 11. Menú Lateral (Sidebar)

**Archivo**: `sidebar_widget.dart`

### Comportamiento por Tamaño de Pantalla

| Pantalla | Comportamiento |
|---------|---------------|
| **Mobile** (< 600px) | Oculto por defecto. Aparece con ícono ☰ hamburguesa. Se muestra como Drawer (deslizante desde la izquierda, con overlay oscuro al fondo) |
| **Tablet** (600-900px) | Visible pero colapsado (solo iconos, sin texto). Al hover/click en un ícono, muestra tooltip con el nombre |
| **Desktop** (> 900px) | Visible y expandido siempre. Muestra iconos + texto. Botón para colapsar a solo iconos |

### Estructura del Sidebar

```
┌────────────────────────────────┐
│                                │
│  ⚡ NexusLED                   │  ← Logo + nombre (clickeable → dashboard)
│                                │
├────────────────────────────────┤
│                                │
│  [Avatar] Carlos García        │  ← Mini-perfil del usuario
│           carlos@email.com     │
│           ● Conectado          │  ← Estado MQTT
│                                │
├────────────────────────────────┤
│                                │
│  PRINCIPAL                     │  ← Sección label
│  ⬛ Dashboard                  │  ← Item activo (fondo glassmorphism)
│  💡 Control LED               │
│  📊 Estadísticas              │
│                                │
├────────────────────────────────┤
│                                │
│  INFORMACIÓN                   │
│  👥 Quiénes Somos             │
│  🚀 Servicios                 │
│  ℹ️  Info del Sistema          │
│                                │
├────────────────────────────────┤
│                                │
│  CONFIGURACIÓN                 │
│  ⚙️  Configuración MQTT        │
│  🆘 Soporte y Ayuda           │
│                                │
├────────────────────────────────┤
│                                │
│  [◀ Colapsar sidebar]         │  ← Solo en desktop
│                                │
└────────────────────────────────┘
```

### Diseño Visual del Sidebar

- **Fondo**: `rgba(26, 5, 51, 0.95)` con efecto glassmorphism
- **Borde derecho**: `1px solid rgba(168, 85, 247, 0.2)` con glow suave
- **Ítem activo**: Fondo glassmorphism morado, borde izquierdo `3px solid #A855F7`, texto blanco brillante
- **Ítem hover**: Transición suave 200ms, fondo levemente más claro
- **Ítem normal**: Texto color lavanda `#C4B5D4`, ícono color `#7C6B8F`
- **Labels de sección**: Texto uppercase, tracking amplio, color `#7C6B8F`, tamaño 10px

### Animación de Collapse/Expand

- Transición de ancho: `240px → 72px` en 300ms, curva `easeInOutCubic`
- El texto desaparece con `opacity: 0` y `translateX(-20px)` en 150ms
- Los íconos se centran con animación
- El botón de toggle rota 180° con `AnimatedRotation`

---

## 12. Navegación y Responsividad

### Router (go_router)

```dart
// Rutas principales de NexusLED
final router = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (ctx, state) => '/splash'),
    GoRoute(path: '/splash', builder: (ctx, state) => SplashScreen()),
    GoRoute(path: '/onboarding', builder: (ctx, state) => OnboardingScreen()),
    GoRoute(path: '/login', builder: (ctx, state) => LoginScreen()),
    GoRoute(path: '/register', builder: (ctx, state) => RegisterScreen()),
    GoRoute(path: '/camera-auth', builder: (ctx, state) => CameraAuthScreen()),
    
    // Shell route: todas las rutas autenticadas comparten el sidebar
    ShellRoute(
      builder: (ctx, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (ctx, state) => DashboardScreen()),
        GoRoute(path: '/control', builder: (ctx, state) => LedControlScreen()),
        GoRoute(path: '/statistics', builder: (ctx, state) => StatisticsScreen()),
        GoRoute(path: '/about', builder: (ctx, state) => AboutScreen()),
        GoRoute(path: '/services', builder: (ctx, state) => ServicesScreen()),
        GoRoute(path: '/system-info', builder: (ctx, state) => SystemInfoScreen()),
        GoRoute(path: '/settings', builder: (ctx, state) => SettingsScreen()),
        GoRoute(path: '/support', builder: (ctx, state) => SupportScreen()),
        GoRoute(path: '/profile', builder: (ctx, state) => ProfileScreen()),
      ],
    ),
  ],
  
  // Guard: redirigir si no está autenticado
  redirect: (context, state) {
    final isLoggedIn = supabase.auth.currentSession != null;
    final publicRoutes = ['/splash', '/onboarding', '/login', '/register', '/camera-auth'];
    if (!isLoggedIn && !publicRoutes.contains(state.fullPath)) return '/login';
    if (isLoggedIn && state.fullPath == '/login') return '/dashboard';
    return null;
  },
);
```

### Layout Principal (MainShell)

```dart
// Para desktop: Row(sidebar + contenido)
// Para tablet: Row(sidebar colapsado + contenido)
// Para mobile: Scaffold con Drawer

Widget build(BuildContext ctx) {
  return LayoutBuilder(
    builder: (ctx, constraints) {
      if (constraints.maxWidth >= 900) {
        // Desktop: sidebar permanente
        return Row(children: [
          SidebarWidget(expanded: constraints.maxWidth >= 1200),
          Expanded(child: child),
        ]);
      } else {
        // Mobile: drawer
        return Scaffold(
          drawer: SidebarWidget(isDrawer: true),
          body: child,
        );
      }
    },
  );
}
```

---

## 13. Permisos de la App Móvil

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<!-- Para Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

### iOS (Info.plist)

```xml
<key>NSCameraUsageDescription</key>
<string>NexusLED usa la cámara para verificar tu identidad de forma segura mediante reconocimiento facial.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>NexusLED accede a tus fotos para que puedas establecer una foto de perfil.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>NexusLED puede guardar imágenes de perfil en tu biblioteca.</string>

<key>NSFaceIDUsageDescription</key>
<string>NexusLED usa Face ID para autenticación rápida y segura.</string>
```

---

## 14. Autenticación con Cámara / Face ID

### ¿Por qué la cámara?

El instructor mencionó que la cámara sirve para "validar al usuario". En NexusLED esto se implementa de dos maneras:

**Opción A — Biometría del sistema (más simple y segura)**:
- Usar el paquete `local_auth` para activar Face ID / huella dactilar del dispositivo
- Flutter llama a la API nativa de Android/iOS
- El resultado es: autenticado ✓ o no ✓
- No se almacena ningún dato biométrico en la app

**Opción B — Verificación facial personalizada (más avanzada)**:
- Al registrarse, el usuario toma una selfie
- La imagen se convierte en descriptor facial (usando paquete `google_mlkit_face_detection`)
- El descriptor (vector de números) se guarda encriptado en Supabase (tabla `profiles.face_descriptor`)
- Al hacer login con cámara:
  1. Se activa la cámara frontal
  2. Se detecta el rostro en tiempo real
  3. Se compara con el descriptor guardado
  4. Si la similitud es > 85% → acceso concedido

**Implementación recomendada para el proyecto**: Opción A (biometría del sistema), es más segura, más rápida de implementar y la industria la usa ampliamente.

### CameraAuthScreen

```
┌─────────────────────────────────────────┐
│  🔒  Verificación de Identidad          │
│                                          │
│  ┌────────────────────────────────┐     │
│  │                                │     │
│  │   [PREVIEW DE CÁMARA]          │     │
│  │   con marco oval pulsante      │     │
│  │   y puntos de referencia       │     │
│  │   faciales animados            │     │
│  │                                │     │
│  └────────────────────────────────┘     │
│                                          │
│  Coloca tu rostro dentro del marco      │
│                                          │
│  ████████████░░░░ 75%                   │
│  Verificando...                          │
│                                          │
│  [Cancelar]    [Usar contraseña]        │
└─────────────────────────────────────────┘
```

---

## 15. Política de Privacidad y Términos

**Pantalla**: Modal o página completa  
**Se muestra**: Al registrarse (enlace clickeable en el checkbox de aceptación)  
**Ruta**: `/privacy` y `/terms`

### Política de Privacidad — Puntos clave

1. **Datos recopilados**: Email, nombre, datos de actividad del LED, información del dispositivo
2. **Datos biométricos**: Se almacenan de forma encriptada únicamente si el usuario activa la autenticación facial. Se pueden eliminar en cualquier momento.
3. **Uso de los datos**: Funcionamiento de la app, estadísticas de uso, mejora del servicio
4. **Retención**: Los datos se conservan mientras la cuenta esté activa. Al eliminar la cuenta, se eliminan en 30 días.
5. **Compartición**: No se comparten datos con terceros, excepto los servicios usados (Supabase, EMQX).
6. **Derechos del usuario**: Acceso, rectificación, eliminación y portabilidad de datos.
7. **Contacto**: soporte@nexusled.app

### Auto-dato (ARDT / Right to be Forgotten)

En la pantalla de Perfil → Sección "Cuenta":
- Botón "Solicitar mis datos" → Genera y descarga un JSON con todos los datos del usuario
- Botón "Eliminar mi cuenta" → Diálogo de confirmación → Proceso de eliminación en 30 días

---

## 16. Simulación del LED sin Arduino

### ¿Cómo demostrar que funciona sin el Arduino físico?

Se implementa un **Simulador de Dispositivo** que puede correr en:
- Una segunda pestaña del navegador
- Un segundo dispositivo (celular, PC)
- Un script de Node.js / Python en el mismo PC

### Opción A — Simulador en la misma app (pantalla especial)

En la pantalla de Información del Sistema, agregar:

```
┌──────────────────────────────────────────┐
│  🔬  Modo Simulación                     │
│  (Para pruebas sin Arduino físico)       │
│                                          │
│  ● Simulador: INACTIVO                  │
│                                          │
│  [ACTIVAR SIMULADOR]                     │
│                                          │
│  Cuando el simulador está activo:        │
│  - Se suscribe a nexusled/led/control    │
│  - Al recibir "ON" → muestra LED verde   │
│  - Al recibir "OFF" → muestra LED rojo   │
│  - Publica confirmación en .../status   │
└──────────────────────────────────────────┘
```

### Opción B — Script Python (para correr en PC)

```python
# simulador_arduino.py
# Ejecutar en PC para simular el Arduino
import paho.mqtt.client as mqtt
import time

BROKER = "broker.emqx.io"
PORT = 1883
TOPIC_CONTROL = "nexusled/led/control"
TOPIC_STATUS = "nexusled/led/status"

led_state = "OFF"

def on_connect(client, userdata, flags, rc):
    print(f"✅ Conectado al broker MQTT (rc={rc})")
    client.subscribe(TOPIC_CONTROL)
    print(f"📡 Suscrito a: {TOPIC_CONTROL}")

def on_message(client, userdata, msg):
    global led_state
    command = msg.payload.decode()
    print(f"📥 Comando recibido: {command}")
    
    if command == "ON":
        led_state = "ON"
        print("💡 LED ENCENDIDO ✅")
        # Simular en pantalla (puede ser con colorama o simplemente print)
    elif command == "OFF":
        led_state = "OFF"
        print("🔴 LED APAGADO ❌")
    
    # Confirmar el estado al broker
    client.publish(TOPIC_STATUS, led_state, retain=True)
    print(f"📤 Estado confirmado: {led_state}")

client = mqtt.Client("simulador_nexusled_arduino")
client.on_connect = on_connect
client.on_message = on_message

print("🚀 Iniciando simulador NexusLED Arduino...")
client.connect(BROKER, PORT, 60)
client.loop_forever()
```

### Opción C — MQTT Explorer (herramienta de escritorio)

1. Descargar MQTT Explorer desde http://mqtt-explorer.com
2. Conectar a `broker.emqx.io:1883`
3. Suscribirse a `nexusled/led/control`
4. Publicar mensajes de "ON" y "OFF" al tópico `nexusled/led/status`
5. Observar en tiempo real cómo la app NexusLED actualiza el UI

Esto permite demostrar el protocolo Publish/Subscribe de forma visual en la presentación.

---

## 17. Flujo MQTT Publish/Subscribe

### El Protocolo Publish/Subscribe Explicado

En NexusLED, hay dos tipos de participantes MQTT:

**PUBLISHERS (quienes publican/envían mensajes)**:
- App NexusLED → publica comandos ON/OFF
- Arduino ESP32 → publica confirmaciones de estado

**SUBSCRIBERS (quienes escuchan/reciben mensajes)**:
- Arduino ESP32 → escucha comandos ON/OFF
- App NexusLED → escucha confirmaciones de estado

**BROKER (intermediario)**:
- EMQX Cloud → recibe todos los mensajes y los distribuye

### Diagrama de Flujo Completo

```
ENCENDER EL LED:

App (Colombia) ──PUBLISH "ON"──► EMQX Broker ──► Arduino ESP32
                Topic: nexus/led/control         (recibe "ON")
                                                      │
                                                 LED se enciende
                                                      │
App (Colombia) ◄──RECEIVE "ON"── EMQX Broker ◄──PUBLISH "ON"
                Topic: nexus/led/status          Confirma estado

APAGAR EL LED:

App (Colombia) ──PUBLISH "OFF"─► EMQX Broker ──► Arduino ESP32
                                                 (recibe "OFF")
                                                      │
                                                  LED se apaga
                                                      │
App (Colombia) ◄──RECEIVE "OFF"─ EMQX Broker ◄──PUBLISH "OFF"
```

### QoS (Quality of Service) — Niveles de garantía

| Nivel | Nombre | Significado | Uso en NexusLED |
|-------|--------|-------------|-----------------|
| **QoS 0** | At most once | El mensaje se envía sin confirmación. Puede perderse. | No recomendado |
| **QoS 1** | At least once | El mensaje llega al menos una vez (puede duplicarse). | **Recomendado** ✅ |
| **QoS 2** | Exactly once | El mensaje llega exactamente una vez. Más lento. | Opcional |

### Retained Messages (Mensajes Retenidos)

Cuando Arduino publica el estado del LED con `retain=true`:
- El broker GUARDA ese mensaje
- Cuando la App se conecta (aunque el Arduino ya publicó hace horas), INMEDIATAMENTE recibe el último estado
- Así la App siempre sabe el estado actual del LED, incluso en la primera conexión

---

## 18. Despliegue — Netlify + GitHub

### Configuración de GitHub

```
Repositorio: github.com/tuusuario/nexusled
Ramas:
  - main (producción)
  - develop (desarrollo)
  - feature/* (características)
```

### Compilar Flutter para Web

```bash
# En la raíz del proyecto Flutter
flutter build web --release --web-renderer canvaskit

# El output estará en: build/web/
```

### Despliegue en Netlify

**Método 1 — Deploy manual**:
1. Ir a netlify.com → "Add new site" → "Deploy manually"
2. Arrastrar la carpeta `build/web/` 
3. Netlify asigna URL: `https://nexusled-xxx.netlify.app`

**Método 2 — Continuous Deployment con GitHub** (recomendado):
1. Netlify → "New site from Git" → Conectar GitHub
2. Seleccionar repositorio `nexusled`
3. Configurar:
   - **Build command**: `flutter build web --release`
   - **Publish directory**: `build/web`
4. Cada push a `main` hace deploy automático

**Archivo `netlify.toml`** (en la raíz del proyecto):
```toml
[build]
  command = "flutter build web --release --web-renderer canvaskit"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

**Archivo `_redirects`** (en carpeta web/):
```
/*    /index.html   200
```
(Necesario para que el routing de go_router funcione en Netlify)

### URL Final

```
Producción: https://nexusled.netlify.app (o dominio personalizado)
```

---

## 19. Animaciones y Efectos

### Animaciones Principales

**Splash Screen**:
- `AnimationController` con duración 3000ms
- Secuencia: logo aparece (0-500ms) → nombre se escribe (500-1500ms) → tagline fade in (1500-2500ms) → progress bar (0-4000ms)

**LED Toggle**:
- `AnimatedContainer` en el ícono del LED: escala + color + sombra
- Duración: 400ms, curva `easeInOutCubic`
- Glow pulse: `AnimationController` que repite indefinidamente cuando LED = ON

**Sidebar**:
- `AnimatedContainer` para el ancho (240px ↔ 72px)
- `AnimatedOpacity` para el texto
- Duración: 300ms, curva `easeInOutQuart`

**Cards del Dashboard**:
- Aparición con `SlideTransition` + `FadeTransition` en cascada (stagger de 100ms entre cards)
- Hover en desktop: `MouseRegion` + `AnimatedContainer` para escala 1.0 → 1.02

**Gráficas**:
- `fl_chart` tiene animaciones de aparición incorporadas
- Activar `FlChartAnimation` con duración 800ms

**Botón de Control LED**:
- Presión: `ScaleTransition` 1.0 → 0.95 → 1.0
- Ripple: efecto de onda con `InkWell`

**Fondo Animado**:
- Partículas flotantes: `CustomPainter` con lista de puntos que se mueven lentamente
- Gradiente animado: `AnimatedContainer` con colores que cambian lentamente

**Loading States**:
- `shimmer` package para skeleton screens
- CircularProgressIndicator con color morado del tema

---

## 20. Seguridad

### Autenticación

- **Supabase Auth**: JWT tokens con refresh automático
- **Row Level Security**: Cada usuario solo accede a sus propios datos
- **Sesiones**: Expiración configurable, logout automático por inactividad

### MQTT

- Para producción: usar EMQX Cloud con TLS/SSL (puerto 8883/8084)
- Credenciales MQTT separadas de las credenciales de la app
- Client ID único por sesión (evitar conflictos)

### Datos Sensibles

- **NO SE USA `.env`**: Toda la configuración MQTT se guarda en Supabase con RLS
- Contraseñas siempre hasheadas (Supabase lo hace automáticamente con bcrypt)
- Datos biométricos: nunca se almacena la imagen, solo el vector descriptor
- Tokens de sesión: solo en memoria o SecureStorage (no SharedPreferences)

### Para la app web (Netlify)

- HTTPS obligatorio (Netlify lo provee automáticamente)
- WebSocket seguro (WSS) para MQTT en la versión web
- CSP headers en `netlify.toml`

---

## 21. Checklist Final de Entrega

### Funcionalidades Core

- [ ] Splash screen de 5 segundos con logo y animación
- [ ] Login y registro funcional con Supabase Auth
- [ ] Autenticación con cámara / biometría implementada
- [ ] Sidebar funcional: desktop expandido, tablet colapsado, mobile drawer
- [ ] Dashboard con carrusel de tarjetas
- [ ] Gráficas de actividad con datos reales de Supabase
- [ ] Control del LED (botones ON/OFF) con MQTT
- [ ] Confirmación de estado desde el dispositivo
- [ ] Pantalla "Quiénes Somos"
- [ ] Pantalla "Servicios"
- [ ] Pantalla "Información del Sistema" con estado en tiempo real
- [ ] Pantalla "Configuración MQTT" completamente funcional (sin .env)
- [ ] Pantalla "Soporte y Ayuda" con FAQ y formulario de ticket
- [ ] Perfil de usuario editable
- [ ] Política de privacidad y términos
- [ ] Permisos mobile (Android/iOS)

### Calidad

- [ ] 100% responsivo: web, móvil (Android/iOS), desktop
- [ ] Diseño glassmorphism aplicado en todos los componentes
- [ ] Gradientes morado/negro en toda la app
- [ ] Tipografías Exo 2, Rajdhani, Nunito Sans, Orbitron aplicadas
- [ ] Animaciones en splash, LED, sidebar, cards
- [ ] Sin Material Design genérico visible
- [ ] Sin Cupertino genérico visible
- [ ] Logo NexusLED propio

### Infraestructura

- [ ] Proyecto en GitHub con commits regulares
- [ ] Deploy en Netlify funcionando (URL pública)
- [ ] Supabase: todas las tablas creadas con RLS
- [ ] EMQX Cloud (o broker público) configurado
- [ ] Simulador de Arduino funcionando para demo

### Documentación

- [ ] README.md en el repositorio
- [ ] Código del Arduino documentado
- [ ] Instrucciones de configuración

---

## 22. Glosario Técnico

| Término | Definición |
|--------|-----------|
| **MQTT** | Message Queuing Telemetry Transport. Protocolo de mensajería ligero para IoT basado en TCP/IP. |
| **Broker** | Servidor intermediario MQTT que recibe, almacena y distribuye mensajes entre clientes. |
| **Publish** | Publicar/enviar un mensaje a un tópico en el broker MQTT. |
| **Subscribe** | Suscribirse a un tópico para recibir mensajes publicados en él. |
| **Tópico** | Cadena de texto que actúa como "canal" en MQTT. Ejemplo: `nexusled/led/control` |
| **QoS** | Quality of Service. Nivel de garantía de entrega de mensajes MQTT (0, 1 o 2). |
| **Retain** | Flag en MQTT que hace que el broker guarde el último mensaje de un tópico para nuevos suscriptores. |
| **Arduino Nano ESP32** | Microcontrolador de bajo costo con WiFi/Bluetooth integrado, compatible con Arduino IDE. |
| **Flutter** | Framework de Google para crear apps multiplataforma desde un único código base en Dart. |
| **Supabase** | Plataforma backend open-source que ofrece base de datos PostgreSQL, autenticación y APIs en tiempo real. |
| **EMQX** | Broker MQTT de alto rendimiento, uno de los más populares en proyectos IoT. |
| **Glassmorphism** | Estilo de diseño UI que simula vidrio esmerilado con transparencia, blur y bordes brillantes. |
| **JWT** | JSON Web Token. Formato estándar para tokens de autenticación. |
| **RLS** | Row Level Security. Política de PostgreSQL que controla qué filas puede ver cada usuario. |
| **PWA** | Progressive Web App. App web que puede instalarse como si fuera nativa. |
| **WebSocket** | Protocolo de comunicación bidireccional en tiempo real sobre HTTP. MQTT puede usarlo para la versión web. |
| **go_router** | Paquete de Flutter para navegación declarativa y gestión de rutas. |
| **Riverpod** | Sistema de gestión de estado reactivo para Flutter. |
| **TLS/SSL** | Transport Layer Security. Encriptación de la comunicación en red. |
| **Netlify** | Plataforma de hosting para sitios web estáticos y SPAs con CI/CD integrado. |
| **IoT** | Internet of Things. Red de dispositivos físicos conectados a internet. |
| **LED** | Light Emitting Diode. Diodo emisor de luz. En este proyecto es el hardware controlado remotamente. |

---

## 📌 NOTAS FINALES

### Orden de implementación recomendado

1. **Setup inicial**: Crear proyecto Flutter, configurar Supabase y EMQX
2. **Autenticación**: Login/registro funcionando con Supabase
3. **Layout base**: Sidebar + MainShell responsivo
4. **MQTT**: Conectar y probar ON/OFF con MQTT Explorer
5. **Dashboard**: Cards, gráficas básicas con datos de prueba
6. **Pantallas de contenido**: About, Services, System Info
7. **Configuración MQTT**: Pantalla de configuración guardando en Supabase
8. **Estadísticas**: Gráficas con datos reales de Supabase
9. **Soporte**: Formulario de tickets
10. **Pulir UI**: Animaciones, efectos, responsive testing
11. **Permisos mobile**: Android + iOS
12. **Build y deploy**: Flutter web → Netlify

### Recursos útiles

- Documentación Flutter: https://docs.flutter.dev
- Documentación Supabase: https://supabase.com/docs
- EMQX Cloud: https://www.emqx.com/en/cloud
- MQTT Explorer: http://mqtt-explorer.com
- fl_chart: https://pub.dev/packages/fl_chart
- go_router: https://pub.dev/packages/go_router
- Lottie animations (gratis): https://lottiefiles.com

---

*Documento generado para el proyecto NexusLED — Control IoT Remoto*  
*Stack: Flutter · EMQX Cloud · Supabase · MQTT*  
*Plataformas: Web · Android · iOS · Desktop*  
*Diseño: Glassmorphism · Gradientes Morado/Negro · Futurista*
