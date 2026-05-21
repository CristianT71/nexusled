import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/glass_card.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const services = [
      _ServiceData(
        Icons.public_rounded,
        'Control Global',
        'Controla tu dispositivo desde cualquier lugar con latencia mínima.',
      ),
      _ServiceData(
        Icons.monitor_heart_rounded,
        'Monitoreo Continuo',
        'Estadísticas en tiempo real de tu dispositivo IoT.',
      ),
      _ServiceData(
        Icons.devices_rounded,
        'Cualquier Dispositivo',
        'Web, Android, iOS y escritorio desde un solo código Flutter.',
      ),
      _ServiceData(
        Icons.lock_rounded,
        'Autenticación Avanzada',
        'Login seguro y validación por cámara o biometría.',
      ),
      _ServiceData(
        Icons.flash_on_rounded,
        'MQTT Ultraligero',
        'Protocolo IoT rápido con publish/subscribe.',
      ),
      _ServiceData(
        Icons.history_rounded,
        'Historial Completo',
        'Cada acción registrada con timestamp, latencia y confirmación.',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(22),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 210,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final item = services[index];
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, color: AppColors.purpleGlow, size: 42),
              const SizedBox(height: 18),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceData {
  const _ServiceData(this.icon, this.title, this.description);

  final IconData icon;
  final String title;
  final String description;
}
