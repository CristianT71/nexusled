import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/mqtt_config_model.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class LedControlScreen extends StatelessWidget {
  const LedControlScreen({
    super.key,
    required this.ledOn,
    required this.connected,
    required this.config,
    required this.stateSince,
    required this.latencyMs,
    required this.onCommand,
  });

  final bool ledOn;
  final bool connected;
  final MqttConfigModel config;
  final DateTime stateSince;
  final int latencyMs;
  final ValueChanged<bool> onCommand;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          GlassCard(
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: connected ? AppColors.ledOn : AppColors.ledOff,
                  size: 14,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${connected ? 'Conectado' : 'Desconectado'} a ${config.brokerHost}:${config.brokerPort}',
                  ),
                ),
                Text(
                  'Tópico: ${config.topicControl}',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          GlassCard(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: ledOn
                          ? [AppColors.ledOn, const Color(0xFF064E3B)]
                          : [const Color(0xFF334155), AppColors.bgSecondary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ledOn
                            ? AppColors.ledOn.withValues(alpha: 0.65)
                            : AppColors.ledOff.withValues(alpha: 0.35),
                        blurRadius: ledOn ? 70 : 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lightbulb_rounded,
                    color: ledOn ? Colors.white : AppColors.textMuted,
                    size: 108,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  ledOn ? '● ENCENDIDO' : '● APAGADO',
                  style: TextStyle(
                    color: ledOn ? AppColors.ledOn : AppColors.ledOff,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Desde hace: ${DateFormatter.durationSince(stateSince)}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  'Última latencia: ${latencyMs}ms',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: [
              NexusButton(
                label: 'ENCENDER',
                onPressed: () => onCommand(true),
                icon: Icons.flash_on_rounded,
                colors: const [Color(0xFF16A34A), AppColors.ledOn],
              ),
              NexusButton(
                label: 'APAGAR',
                onPressed: () => onCommand(false),
                icon: Icons.power_settings_new_rounded,
                colors: const [Color(0xFF991B1B), AppColors.ledOff],
              ),
              NexusButton(
                label: 'ALTERNAR',
                onPressed: () => onCommand(!ledOn),
                icon: Icons.sync_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
