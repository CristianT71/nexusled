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
                _ColorControlRow(
                  label: 'RED',
                  color: Colors.red,
                  onTurnOn: () => onColorCommand('red'),
                  onTurnOff: () => onColorCommand('off'),
                ),
                const SizedBox(height: 12),
                _ColorControlRow(
                  label: 'GREEN',
                  color: Colors.green,
                  onTurnOn: () => onColorCommand('green'),
                  onTurnOff: () => onColorCommand('off'),
                ),
                const SizedBox(height: 12),
                _ColorControlRow(
                  label: 'BLUE',
                  color: Colors.blue,
                  onTurnOn: () => onColorCommand('blue'),
                  onTurnOff: () => onColorCommand('off'),
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

class _ColorControlRow extends StatelessWidget {
  const _ColorControlRow({
    required this.label,
    required this.color,
    required this.onTurnOn,
    required this.onTurnOff,
  });

  final String label;
  final Color color;
  final VoidCallback onTurnOn;
  final VoidCallback onTurnOff;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label[0],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onTurnOn,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('ON'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onTurnOff,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('OFF'),
        ),
      ],
    );
  }
}
