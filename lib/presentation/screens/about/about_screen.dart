import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_visual_styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const featureStyle = NexusInfoTileStyle();
    const badgeStyle = NexusBadgeStyle();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  color: AppColors.accentGlow,
                  size: 64,
                ),
                const SizedBox(height: 14),
                const Text(
                  'NexusLED',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tu hardware, a la distancia de un toque.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'NexusLED nace de la necesidad de conectar el mundo físico con el digital de manera simple, segura y accesible. Creemos que el IoT debe estar al alcance de todos.',
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Acerca de Este Proyecto',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/Images/Grupo_NexusLed.png',
                      width: kIsWeb ? 700 : double.infinity,
                      height: kIsWeb ? 500 : null,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error cargando imagen: $error');
                        return Container(
                          height: 200,
                          color: AppColors.brightBlue.withValues(alpha: 0.1),
                          child: const Center(
                            child: Text(
                              'Imagen no disponible',
                              style: TextStyle(
                                color: Color.fromARGB(255, 201, 148, 160),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'NexusLED es un proyecto desarrollado por aprendices del SENA en el programa Tecnólogo en Análisis y Desarrollo de Software.',
                  style: TextStyle(
                    color: AppColors.textPrimary.withValues(alpha: 0.85),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Somos aprendices comprometidos en aplicar conocimientos en:',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                const _FeatureItem(
                  icon: Icons.code_rounded,
                  title: 'Desarrollo de Software',
                  description:
                      'Aplicación web y móvil con Flutter para una interfaz intuitiva y moderna.',
                  style: featureStyle,
                ),
                const _FeatureItem(
                  icon: Icons.hardware_rounded,
                  title: 'IoT y Sistemas Embebidos',
                  description:
                      'Integración de Arduino Nano ESP32 con protocolos MQTT para control remoto.',
                  style: featureStyle,
                ),
                const _FeatureItem(
                  icon: Icons.cloud_rounded,
                  title: 'Servicios en la Nube',
                  description:
                      'EMQX como broker MQTT y Supabase para autenticación y base de datos en tiempo real.',
                  style: featureStyle,
                ),
                const _FeatureItem(
                  icon: Icons.security_rounded,
                  title: 'Seguridad y Autenticación',
                  description:
                      'Implementación de buenas prácticas en seguridad, encriptación y control de acceso.',
                  style: featureStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tecnologías Utilizadas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _TechBadge('Flutter', style: badgeStyle),
                    _TechBadge('Dart', style: badgeStyle),
                    _TechBadge('Arduino', style: badgeStyle),
                    _TechBadge('ESP32', style: badgeStyle),
                    _TechBadge('MQTT', style: badgeStyle),
                    _TechBadge('EMQX', style: badgeStyle),
                    _TechBadge('Supabase', style: badgeStyle),
                    _TechBadge('PostgreSQL', style: badgeStyle),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.style,
  });

  final IconData icon;
  final String title;
  final String description;
  final NexusInfoTileStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: style.bottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: style.iconColor, size: style.iconSize),
          SizedBox(width: style.gap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: style.titleStyle),
                Text(description, style: style.descriptionStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  const _TechBadge(this.label, {required this.style});

  final String label;
  final NexusBadgeStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor.withValues(alpha: style.backgroundOpacity),
        border: Border.all(
          color: style.borderColor.withValues(alpha: style.borderOpacity),
          width: style.borderWidth,
        ),
        borderRadius: BorderRadius.circular(style.borderRadius),
      ),
      child: Text(label, style: style.labelStyle),
    );
  }
}
