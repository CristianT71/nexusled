import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/mqtt_config_model.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';
import '../../widgets/common/nexus_visual_styles.dart';

class SystemInfoScreen extends StatelessWidget {
  const SystemInfoScreen({
    super.key,
    required this.ledOn,
    required this.connected,
    required this.simulatorActive,
    required this.sent,
    required this.received,
    required this.latencyMs,
    required this.stateSince,
    required this.config,
    required this.onReconnect,
    required this.onSimulatorChanged,
  });

  final bool ledOn;
  final bool connected;
  final bool simulatorActive;
  final int sent;
  final int received;
  final int latencyMs;
  final DateTime stateSince;
  final MqttConfigModel config;
  final VoidCallback onReconnect;
  final ValueChanged<bool> onSimulatorChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          _InfoCard(
            title: 'Arduino Nano ESP32',
            icon: Icons.memory_rounded,
            rows: [
              'Estado LED: ${ledOn ? 'ENCENDIDO' : 'APAGADO'}',
              'Estado: ${simulatorActive ? 'Simulador en línea' : 'Esperando hardware'}',
              'Firmware: v1.0.0',
              'Tiempo de estado: ${_durationLabel(DateTime.now().difference(stateSince))}',
            ],
            cardStyle: const GlassCardStyle(),
            headerStyle: const NexusInfoTileStyle(
              iconColor: AppColors.cyanGlow,
              titleStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              descriptionStyle: TextStyle(color: AppColors.textSecondary),
              iconSize: 24,
              gap: 10,
              bottomPadding: 0,
            ),
            rowStyle: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Conexión MQTT',
            icon: Icons.hub_rounded,
            rows: [
              'Broker: ${config.brokerHost}',
              'Puerto MQTT: ${config.brokerPort}',
              'Puerto WebSocket: ${config.websocketPort}',
              'Estado: ${connected ? 'Conectado' : 'Desconectado'}',
              'Latencia: ${latencyMs}ms',
              'Mensajes enviados: $sent',
              'Mensajes recibidos: $received',
            ],
            cardStyle: GlassCardStyle(
              backgroundColor: connected ? AppColors.ledOn : AppColors.ledOff,
              borderColor: connected ? AppColors.ledOn : AppColors.ledOff,
              shadowColor: connected ? AppColors.ledOn : AppColors.ledOff,
              backgroundOpacity: 0.05,
              borderOpacity: 0.24,
              shadowOpacity: 0.16,
            ),
            headerStyle: const NexusInfoTileStyle(
              iconColor: AppColors.cyanGlow,
              titleStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              descriptionStyle: TextStyle(color: AppColors.textSecondary),
              iconSize: 24,
              gap: 10,
              bottomPadding: 0,
            ),
            rowStyle: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          GlassCard(
            style: GlassCardStyle(
              backgroundColor:
                  simulatorActive ? AppColors.ledOn : AppColors.ledConnecting,
              borderColor:
                  simulatorActive ? AppColors.ledOn : AppColors.ledConnecting,
              shadowColor:
                  simulatorActive ? AppColors.ledOn : AppColors.ledConnecting,
              backgroundOpacity: 0.05,
              borderOpacity: 0.26,
              shadowOpacity: 0.16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Modo Simulación',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Permite operar en modo local cuando no hay Arduino físico conectado.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: simulatorActive,
                  onChanged: onSimulatorChanged,
                  title: Text(
                    simulatorActive ? 'Simulador activo' : 'Simulador inactivo',
                  ),
                ),
                const SizedBox(height: 12),
                NexusButton(
                  label: 'FORZAR RECONEXIÓN MQTT',
                  onPressed: onReconnect,
                  icon: Icons.refresh_rounded,
                  style: const NexusButtonStyle(
                    gradientColors: [Color(0xFF0F766E), Color(0xFF155E75)],
                    borderColor: Color(0xFF67E8F9),
                    borderWidth: 1,
                    shadowOpacity: 0.22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _durationLabel(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m ${seconds}s';
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.rows,
    required this.cardStyle,
    required this.headerStyle,
    required this.rowStyle,
  });

  final String title;
  final IconData icon;
  final List<String> rows;
  final GlassCardStyle cardStyle;
  final NexusInfoTileStyle headerStyle;
  final TextStyle rowStyle;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      style: cardStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: headerStyle.iconColor, size: headerStyle.iconSize),
              SizedBox(width: headerStyle.gap),
              Text(title, style: headerStyle.titleStyle),
            ],
          ),
          const SizedBox(height: 12),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(row, style: rowStyle),
            ),
        ],
      ),
    );
  }
}
