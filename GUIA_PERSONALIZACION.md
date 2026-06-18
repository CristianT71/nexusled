# Guía rápida de personalización - NexusLED

Esta guía está hecha para cambiar el diseño **sin dañar otras partes**.

---

# 1. Regla principal

## Si quieres cambiar solo 1 cosa
Toca **la instancia específica** en la pantalla.

## Si quieres cambiar muchas cosas a la vez
Toca el archivo base o las constantes globales.

---

# 2. Regla más importante del proyecto

## No cambies esto si solo quieres modificar un elemento puntual

- `lib/presentation/widgets/common/glass_card.dart`
- `lib/presentation/widgets/common/nexus_button.dart`

Porque esos archivos son la base reutilizable.

Si cambias ahí:
- muchas tarjetas cambian
- muchos botones cambian

## Sí cambia esto si quieres modificar solo un elemento

La pantalla donde está ese elemento.

Ejemplos:
- `lib/presentation/screens/about/about_screen.dart`
- `lib/presentation/screens/services/services_screen.dart`
- `lib/presentation/screens/profile/profile_screen.dart`
- `lib/presentation/screens/system_info/system_info_screen.dart`

---

# 3. Dónde se cambia cada cosa

## A. Color global de la app
Archivo:

- `lib/core/constants/app_colors.dart`

Ahí están colores como:
- `bgPrimary`
- `bgSecondary`
- `textPrimary`
- `textSecondary`
- `ledOn`
- `ledOff`
- `accentGlow`

Ejemplo:

```dart
static const bgPrimary = Color(0xFF000000);
```

Usa esto solo si quieres que el cambio se vea en muchas partes.

---

## B. Tema global de inputs y app
Archivo:

- `lib/core/theme/app_theme.dart`

Ahí puedes cambiar:
- fondo general
- fuente
- estilo de `TextField`
- bordes globales de inputs

Ejemplo:

```dart
fontFamily: 'Roboto',
```

---

## C. Tarjetas individuales
Normalmente se cambian en la pantalla donde aparecen.

Las tarjetas usan:

- `GlassCard`
- `GlassCardStyle`

Ejemplo base:

```dart
GlassCard(
  style: const GlassCardStyle(
    backgroundColor: AppColors.cyanGlow,
    backgroundOpacity: 0.08,
    borderColor: AppColors.cyanGlow,
    borderOpacity: 0.28,
    shadowColor: AppColors.cyanGlow,
    shadowOpacity: 0.18,
    borderRadius: 24,
  ),
  child: ...
)
```

### Qué cambia aquí
- `backgroundColor` = color base
- `backgroundOpacity` = transparencia del fondo
- `borderColor` = color del borde
- `borderOpacity` = transparencia del borde
- `borderWidth` = grosor del borde
- `shadowColor` = color de la sombra
- `shadowOpacity` = transparencia de la sombra
- `shadowBlurRadius` = fuerza de la sombra
- `borderRadius` = redondeado
- `blurSigmaX`, `blurSigmaY` = desenfoque del efecto glass

---

## D. Botones individuales
Los botones usan:

- `NexusButton`
- `NexusButtonStyle`

Ejemplo:

```dart
NexusButton(
  label: 'GUARDAR',
  onPressed: _save,
  icon: Icons.save_rounded,
  style: const NexusButtonStyle(
    gradientColors: [AppColors.purpleAccent, AppColors.purpleBright],
    borderColor: Color(0xFF93C5FD),
    borderWidth: 1,
    borderRadius: 14,
  ),
)
```

### Qué cambia aquí
- `gradientColors` = colores del botón
- `foregroundColor` = color del texto e ícono
- `borderColor` = color del borde
- `borderWidth` = grosor del borde
- `borderRadius` = redondeado
- `padding` = tamaño interior del botón
- `shadowColor` = color de sombra
- `shadowOpacity` = transparencia de sombra
- `shadowBlurRadius` = intensidad de sombra
- `textStyle` = estilo del texto

---

## E. Texto
El texto se cambia directamente en el widget `Text`.

Ejemplo:

```dart
Text(
  'Hola',
  style: const TextStyle(
    color: Colors.red,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  ),
)
```

### Lo más usado
- `color`
- `fontSize`
- `fontWeight`
- `height`
- `letterSpacing`

---

## F. Imágenes
Las imágenes se cambian donde aparece `Image.asset`, `Image.network` o un widget similar.

Ejemplo:

```dart
Image.asset(
  'assets/Images/Grupo_NexusLed.png',
  width: 700,
  height: 500,
  fit: BoxFit.cover,
)
```

### Lo más usado
- `width`
- `height`
- `fit`

Si la imagen está dentro de un `ClipRRect`, también puedes cambiar sus esquinas:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.asset(...),
)
```

---

# 4. Tamaño: cómo se cambia de verdad

## El style cambia cómo se ve
Ejemplo:
- color
- borde
- sombra
- opacidad

## El tamaño se cambia con layout
Ejemplo:
- `padding`
- `SizedBox`
- `Container`
- `ConstrainedBox`
- `width`
- `height`

---

## Ejemplo: hacer más grande una tarjeta

```dart
SizedBox(
  width: 700,
  child: GlassCard(
    padding: const EdgeInsets.all(28),
    style: const GlassCardStyle(
      backgroundColor: AppColors.cyanGlow,
      borderColor: AppColors.cyanGlow,
      shadowColor: AppColors.cyanGlow,
    ),
    child: ...
  ),
)
```

### Aquí:
- `width: 700` = tamaño externo
- `padding: EdgeInsets.all(28)` = tamaño interno
- `style` = apariencia

---

## Ejemplo: hacer más grande un botón

```dart
NexusButton(
  label: 'PROBAR',
  onPressed: _test,
  style: const NexusButtonStyle(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 22),
    borderRadius: 18,
  ),
)
```

---

# 5. Ejemplo real: cambiar solo la tarjeta "Acerca de Este Proyecto"

Archivo:

- `lib/presentation/screens/about/about_screen.dart`

Busca esta parte:

```dart
GlassCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Acerca de Este Proyecto',
```

Si quieres cambiar solo esa tarjeta, haz esto:

```dart
GlassCard(
  style: const GlassCardStyle(
    backgroundColor: AppColors.cyanGlow,
    backgroundOpacity: 0.08,
    borderColor: AppColors.cyanGlow,
    borderOpacity: 0.28,
    shadowColor: AppColors.cyanGlow,
    shadowOpacity: 0.18,
    borderRadius: 24,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Acerca de Este Proyecto',
```

## Eso solo cambia esa tarjeta
No cambia:
- la primera card de About
- la card de tecnologías
- otras pantallas

---

# 6. Ejemplo real: cambiar el tamaño de la imagen de About

Archivo:

- `lib/presentation/screens/about/about_screen.dart`

Busca esto:

```dart
Image.asset(
  'assets/Images/Grupo_NexusLed.png',
  width: kIsWeb ? 700 : double.infinity,
  height: kIsWeb ? 500 : null,
  fit: BoxFit.cover,
)
```

Puedes cambiarlo por ejemplo a:

```dart
Image.asset(
  'assets/Images/Grupo_NexusLed.png',
  width: kIsWeb ? 850 : double.infinity,
  height: kIsWeb ? 550 : null,
  fit: BoxFit.cover,
)
```

---

# 7. Ejemplo real: cambiar solo un botón

## Botón normal
Archivo:

- `lib/presentation/screens/auth/login_screen.dart`

Busca:

```dart
NexusButton(
  label: widget.loading ? 'CONECTANDO...' : 'INICIAR SESIÓN',
```

Si quieres cambiar solo ese botón:

```dart
NexusButton(
  label: widget.loading ? 'CONECTANDO...' : 'INICIAR SESIÓN',
  onPressed: ...,
  icon: Icons.login_rounded,
  style: const NexusButtonStyle(
    gradientColors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
    borderColor: Color(0xFF93C5FD),
    borderWidth: 1,
    borderRadius: 16,
  ),
)
```

---

## Botón destructivo
Ejemplo ya existente:

Archivo:

- `lib/presentation/screens/profile/profile_screen.dart`

Busca:

```dart
NexusButton(
  label: 'CERRAR SESIÓN',
```

Ese ya tiene estilo propio, por eso no afecta a otros botones.

---

# 8. Ejemplo real: tarjetas con color por estado

Archivo:

- `lib/presentation/screens/system_info/system_info_screen.dart`

Ejemplo que ya existe:

```dart
cardStyle: GlassCardStyle(
  backgroundColor: connected ? AppColors.ledOn : AppColors.ledOff,
  borderColor: connected ? AppColors.ledOn : AppColors.ledOff,
  shadowColor: connected ? AppColors.ledOn : AppColors.ledOff,
  backgroundOpacity: 0.05,
  borderOpacity: 0.24,
  shadowOpacity: 0.16,
),
```

Eso significa:
- si está conectado, la tarjeta toma un color
- si está desconectado, toma otro
- sin afectar otras tarjetas

---

# 9. Ejemplo real: estilos repetidos pero controlados

## Services
Archivo:

- `lib/presentation/screens/services/services_screen.dart`

Ahí existe un estilo repetido controlado:

```dart
const defaultCardStyle = GlassCardStyle();
```

y cada servicio usa propiedades separadas como:
- `accentColor`
- `cardStyle`
- `titleStyle`
- `descriptionStyle`

Eso permite que cada tarjeta de servicio pueda personalizarse sin tocar las demás.

---

## About - badges y feature items
Archivo:

- `lib/presentation/screens/about/about_screen.dart`

Ahí existen estilos reutilizables:

```dart
const featureStyle = NexusInfoTileStyle();
const badgeStyle = NexusBadgeStyle();
```

Eso sirve para:
- cambiar varias badges iguales a la vez
- cambiar varias filas informativas iguales a la vez

Si quieres cambiar solo una badge, debes tocar esa instancia concreta.

---

# 10. Elementos pequeños parametrizados

## Chips del perfil
Archivo:

- `lib/presentation/screens/profile/profile_screen.dart`

El widget `_ProfileChip` ya acepta:

- `backgroundColor`
- `backgroundOpacity`
- `borderColor`
- `borderOpacity`
- `iconColor`
- `textStyle`
- `padding`

## Tarjetas pequeñas del perfil
Archivo:

- `lib/presentation/screens/profile/profile_screen.dart`

El widget `_ProfileInfoCard` ya acepta:

- `backgroundColor`
- `backgroundOpacity`
- `borderColor`
- `borderOpacity`
- `iconColor`
- `titleStyle`
- `valueStyle`
- `padding`

---

# 11. Casos rápidos

## Quiero cambiar solo el color de una tarjeta
Toca la instancia del `GlassCard` en esa pantalla.

## Quiero cambiar solo el color de un botón
Toca ese `NexusButton` y agrega o cambia `style: NexusButtonStyle(...)`.

## Quiero cambiar solo el tamaño de una imagen
Cambia `width`, `height` o `fit` en `Image.asset` o `Image.network`.

## Quiero cambiar solo el texto
Cambia el `TextStyle` de ese `Text`.

## Quiero cambiar varios inputs de toda la app
Toca `lib/core/theme/app_theme.dart`.

## Quiero cambiar varios colores de toda la app
Toca `lib/core/constants/app_colors.dart`.

---

# 12. Qué archivo tocar según lo que quieres cambiar

## Global
- `lib/core/constants/app_colors.dart`
- `lib/core/theme/app_theme.dart`

## Tarjetas y botones base
- `lib/presentation/widgets/common/glass_card.dart`
- `lib/presentation/widgets/common/nexus_button.dart`
- `lib/presentation/widgets/common/nexus_visual_styles.dart`

## Pantallas
- `lib/presentation/screens/about/about_screen.dart`
- `lib/presentation/screens/services/services_screen.dart`
- `lib/presentation/screens/profile/profile_screen.dart`
- `lib/presentation/screens/system_info/system_info_screen.dart`
- `lib/presentation/screens/settings/settings_screen.dart`
- `lib/presentation/screens/settings/http_settings_screen.dart`
- `lib/presentation/screens/settings/other_protocols_screen.dart`
- `lib/presentation/screens/support/support_screen.dart`
- `lib/presentation/screens/splash_screen.dart`

---

# 13. Regla final para no romper nada

## Si quieres cambiar solo un elemento
No cambies el widget base.

## Si quieres cambiar una familia completa de elementos
Sí puedes cambiar:
- `AppColors`
- `AppTheme`
- estilos comunes en `nexus_visual_styles.dart`

---

# 14. Resumen ultra corto

- `style` = cómo se ve
- `padding / width / height / SizedBox / Container` = cuánto mide
- cambiar una instancia = cambio local
- cambiar un archivo base = cambio global

---

# 15. Ejemplo mínimo para recordar

## Tarjeta local

```dart
GlassCard(
  style: const GlassCardStyle(
    backgroundColor: AppColors.cyanGlow,
    borderColor: AppColors.cyanGlow,
    shadowColor: AppColors.cyanGlow,
  ),
  child: ...
)
```

## Botón local

```dart
NexusButton(
  label: 'GUARDAR',
  onPressed: _save,
  style: const NexusButtonStyle(
    gradientColors: [AppColors.purpleAccent, AppColors.purpleBright],
    borderColor: Color(0xFF93C5FD),
    borderWidth: 1,
  ),
)
```

## Imagen

```dart
Image.asset(
  'assets/Images/Grupo_NexusLed.png',
  width: 800,
  height: 500,
  fit: BoxFit.cover,
)
```

## Texto

```dart
Text(
  'Título',
  style: const TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  ),
)
```
