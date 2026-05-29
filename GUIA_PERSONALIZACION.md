# Guía de Personalización - NexusLED

Este documento explica dónde están definidos los colores, tamaños, textos y propiedades principales de la aplicación para facilitar cambios rápidos.

## 🎨 Colores

**Archivo:** `lib/core/constants/app_colors.dart`

Todos los colores de la aplicación están centralizados en la clase `AppColors`. Para cambiar el esquema de colores, modifica estos valores:

### Colores de fondo
- `bgPrimary` - Fondo principal (muy oscuro)
- `bgSecondary` - Fondo secundario (tarjetas, paneles)
- `deepBlue` - Azul profundo técnico
- `accentBlue` - Azul medio técnico
- `brightBlue` - Azul eléctrico
- `neonBlue` - Cian neón
- `accentGlow` - Brillo azul cielo

### Colores de texto
- `textPrimary` - Texto principal (blanco azulado)
- `textSecondary` - Texto secundario (gris azulado)
- `textMuted` - Texto deshabilitado (gris azulado)

### Indicadores de estado LED
- `ledOn` - LED encendido (verde esmeralda)
- `ledOff` - LED apagado (rojo)
- `ledConnecting` - LED conectando (ámbar)
- `ledUnknown` - LED desconocido (gris)

### Alias de compatibilidad
- `purpleDeep` → `deepBlue`
- `purpleMid` → `accentBlue`
- `purpleAccent` → `brightBlue`
- `purpleBright` → `neonBlue`
- `purpleGlow` → `accentGlow`

**Ejemplo de cambio:**
```dart
// Cambiar el color de fondo principal
static const bgPrimary = Color(0xFF000000); // Negro puro
```

---

## 🎨 Tema Global

**Archivo:** `lib/core/theme/app_theme.dart`

El tema global de la aplicación se define en `AppTheme.dark()`. Aquí se configuran:

- `brightness` - Modo claro/oscuro
- `scaffoldBackgroundColor` - Color de fondo de Scaffold
- `colorScheme` - Esquema de colores de Material 3
- `fontFamily` - Fuente de texto
- `useMaterial3` - Uso de Material Design 3
- `inputDecorationTheme` - Estilo de campos de entrada

**Ejemplo de cambio:**
```dart
// Cambiar la fuente
fontFamily: 'Roboto',

// Cambiar el color de fondo
scaffoldBackgroundColor: AppColors.bgSecondary,
```

---

## 📝 Textos Constantes

**Archivo:** `lib/core/constants/app_strings.dart`

Textos que se usan en múltiples lugares de la aplicación:

- `appName` - Nombre de la aplicación
- `tagline` - Eslogan
- `defaultBroker` - Broker MQTT por defecto
- `defaultControlTopic` - Tópico de control por defecto
- `defaultStatusTopic` - Tópico de estado por defecto

**Ejemplo de cambio:**
```dart
static const appName = 'Mi App LED';
```

---

## 📐 Tamaños y Propiedades en Pantallas

Las pantallas individuales tienen sus propios tamaños y propiedades. La estructura es:

```
lib/presentation/screens/
├── about/
│   └── about_screen.dart
├── auth/
│   ├── login_screen.dart
│   └── register_screen.dart
├── control/
│   └── control_screen.dart
├── dashboard/
│   └── dashboard_screen.dart
├── profile/
│   └── profile_screen.dart
├── statistics/
│   └── statistics_screen.dart
└── system_info/
    └── system_info_screen.dart
```

### Ejemplos de cambios comunes:

#### Cambiar tamaño de un elemento
```dart
// En cualquier pantalla
SizedBox(
  height: 200, // Cambia este valor
  child: Widget(),
)
```

#### Cambiar tamaño de texto
```dart
Text(
  'Hola',
  style: TextStyle(
    fontSize: 24, // Cambia este valor
    fontWeight: FontWeight.bold,
  ),
)
```

#### Cambiar espaciado
```dart
const SizedBox(height: 16), // Cambia este valor
```

#### Cambiar bordes redondeados
```dart
BorderRadius.circular(12), // Cambia este valor
```

---

## 🧩 Componentes Reutilizables

**Directorio:** `lib/presentation/widgets/

Componentes que se usan en múltiples pantallas:

- `sidebar/` - Barra lateral de navegación
- `common/` - Componentes comunes (tarjetas, botones, etc.)
- `led/` - Componentes específicos de LED

### Ejemplo: Cambiar tamaño de avatar en sidebar
**Archivo:** `lib/presentation/widgets/sidebar/sidebar_widget.dart`

Busca la sección del avatar y modifica:
```dart
CircleAvatar(
  radius: 24, // Cambia este valor
  ...
)
```

---

## 📱 Estructura del Proyecto

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # Colores
│   │   └── app_strings.dart    # Textos constantes
│   └── theme/
│       └── app_theme.dart      # Tema global
├── data/
│   ├── models/                 # Modelos de datos
│   └── services/              # Servicios (MQTT, Supabase, etc.)
├── presentation/
│   ├── screens/               # Pantallas
│   ├── state/                 # Estado de la aplicación
│   └── widgets/               # Componentes reutilizables
└── main.dart                  # Punto de entrada
```

---

## 🔄 Cambios Rápidos Más Comunes

### Cambiar el color de fondo de toda la app
1. Ve a `lib/core/constants/app_colors.dart`
2. Modifica `bgPrimary`

### Cambiar el color de los botones de LED
1. Ve a `lib/core/constants/app_colors.dart`
2. Modifica `ledOn` y `ledOff`

### Cambiar el nombre de la app
1. Ve a `lib/core/constants/app_strings.dart`
2. Modifica `appName`

### Cambiar la fuente de toda la app
1. Ve a `lib/core/theme/app_theme.dart`
2. Modifica `fontFamily`

### Cambiar el tamaño de los gráficos
1. Ve a `lib/presentation/screens/dashboard/dashboard_screen.dart`
2. Busca `SizedBox(height: 280)` en el gráfico y modifica el valor

### Cambiar el tamaño de los botones
1. Ve a la pantalla específica (ej. `control_screen.dart`)
2. Busca los botones y modifica sus `SizedBox` o `Container`

---

## ⚠️ Notas Importantes

- Los cambios en `app_colors.dart` afectan a toda la aplicación
- Los cambios en `app_theme.dart` afectan a componentes de Material Design
- Los cambios en pantallas individuales solo afectan a esa pantalla
- Siempre prueba los cambios en múltiples pantallas para verificar consistencia
- Los colores están en formato hexadecimal `0xFFRRGGBB`

---

## 🛠️ Herramientas Útiles

- **Selector de colores:** Usa herramientas como [ColorHex](https://colorhexa.com/) para obtener valores hexadecimales
- **Material Design:** Consulta [Material Design 3](https://m3.material.io/) para guías de diseño
- **Flutter docs:** [Flutter Documentation](https://docs.flutter.dev/) para referencia de widgets
