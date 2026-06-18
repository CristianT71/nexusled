import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_visual_styles.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultCardStyle = GlassCardStyle();
    const titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);
    const descriptionStyle = TextStyle(
      color: AppColors.textSecondary,
      height: 1.4,
    );

    const services = [
      _ServiceData(
        icon: Icons.public_rounded,
        title: 'Control Global',
        description:
            'Controla tu dispositivo desde cualquier lugar con latencia mínima.',
        accentColor: AppColors.purpleGlow,
        cardStyle: defaultCardStyle,
        titleStyle: titleStyle,
        descriptionStyle: descriptionStyle,
      ),
      _ServiceData(
        icon: Icons.monitor_heart_rounded,
        title: 'Monitoreo Continuo',
        description: 'Estadísticas en tiempo real de tu dispositivo IoT.',
        accentColor: AppColors.cyanGlow,
        cardStyle: defaultCardStyle,
        titleStyle: titleStyle,
        descriptionStyle: descriptionStyle,
      ),
      _ServiceData(
        icon: Icons.devices_rounded,
        title: 'Cualquier Dispositivo',
        description:
            'Web, Android, iOS y escritorio desde un solo código Flutter.',
        accentColor: AppColors.blueElectric,
        cardStyle: defaultCardStyle,
        titleStyle: titleStyle,
        descriptionStyle: descriptionStyle,
      ),
      _ServiceData(
        icon: Icons.lock_rounded,
        title: 'Autenticación Avanzada',
        description: 'Login seguro y validación por cámara o biometría.',
        accentColor: AppColors.accentGlow,
        cardStyle: defaultCardStyle,
        titleStyle: titleStyle,
        descriptionStyle: descriptionStyle,
      ),
      _ServiceData(
        icon: Icons.flash_on_rounded,
        title: 'MQTT Ultraligero',
        description: 'Protocolo IoT rápido con publish/subscribe.',
        accentColor: AppColors.ledConnecting,
        cardStyle: defaultCardStyle,
        titleStyle: titleStyle,
        descriptionStyle: descriptionStyle,
      ),
      _ServiceData(
        icon: Icons.history_rounded,
        title: 'Historial Completo',
        description:
            'Cada acción registrada con timestamp, latencia y confirmación.',
        accentColor: AppColors.neonBlue,
        cardStyle: defaultCardStyle,
        titleStyle: titleStyle,
        descriptionStyle: descriptionStyle,
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(22),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 210,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final item = services[index];
        return _ServiceCard(item: item);
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});

  final _ServiceData item;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      style: item.cardStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, color: item.accentColor, size: 42),
          const SizedBox(height: 18),
          Text(item.title, style: item.titleStyle),
          const SizedBox(height: 10),
          Text(item.description, style: item.descriptionStyle),
        ],
      ),
    );
  }
}

class _ServiceData {
  const _ServiceData({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.cardStyle,
    required this.titleStyle,
    required this.descriptionStyle,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final GlassCardStyle cardStyle;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
}
