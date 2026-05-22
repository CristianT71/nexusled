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
    required this.ledColor,
    required this.onColorCommand,
  });

  final bool ledOn;
  final bool connected;
  final MqttConfigModel config;
  final DateTime stateSince;
  final int latencyMs;
  final ValueChanged<bool> onCommand;
  final String ledColor;
  final ValueChanged<String> onColorCommand;

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
                          ? [_getLedColor(ledColor), const Color(0xFF064E3B)]
                          : [const Color(0xFF334155), AppColors.bgSecondary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ledOn
                            ? _getLedColor(ledColor).withValues(alpha: 0.65)
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
          const SizedBox(height: 22),
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Control RGB',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _ColorButton(
                      label: 'RED',
                      color: Colors.red,
                      onPressed: () => onColorCommand('red'),
                    ),
                    _ColorButton(
                      label: 'GREEN',
                      color: Colors.green,
                      onPressed: () => onColorCommand('green'),
                    ),
                    _ColorButton(
                      label: 'BLUE',
                      color: Colors.blue,
                      onPressed: () => onColorCommand('blue'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLedColor(String color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      default:
        return AppColors.ledOn;
    }
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
