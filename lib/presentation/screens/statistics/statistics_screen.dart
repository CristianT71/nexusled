import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/led_event_model.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_visual_styles.dart';
import '../../widgets/dashboard/stat_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    super.key,
    required this.events,
    required this.latencyMs,
  });

  final List<LedEventModel> events;
  final int latencyMs;

  @override
  Widget build(BuildContext context) {
    final onCount = events.where((event) => event.newState == 'ON').length;
    final offCount = events.where((event) => event.newState == 'OFF').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 240,
                child: StatCard(
                  title: 'Total eventos',
                  value: '${events.length}',
                  icon: Icons.timeline_rounded,
                  cardStyle: const GlassCardStyle(),
                ),
              ),
              SizedBox(
                width: 240,
                child: StatCard(
                  title: 'Promedio latencia',
                  value: '${latencyMs}ms',
                  icon: Icons.speed_rounded,
                  color: AppColors.cyanGlow,
                  cardStyle: const GlassCardStyle(
                    backgroundColor: AppColors.cyanGlow,
                    borderColor: AppColors.cyanGlow,
                    shadowColor: AppColors.cyanGlow,
                    backgroundOpacity: 0.06,
                    borderOpacity: 0.2,
                    shadowOpacity: 0.12,
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                child: StatCard(
                  title: 'Encendidos',
                  value: '$onCount',
                  icon: Icons.lightbulb_rounded,
                  color: AppColors.ledOn,
                  cardStyle: const GlassCardStyle(
                    backgroundColor: AppColors.ledOn,
                    borderColor: AppColors.ledOn,
                    shadowColor: AppColors.ledOn,
                    backgroundOpacity: 0.06,
                    borderOpacity: 0.2,
                    shadowOpacity: 0.12,
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                child: StatCard(
                  title: 'Apagados',
                  value: '$offCount',
                  icon: Icons.power_off_rounded,
                  color: AppColors.ledOff,
                  cardStyle: const GlassCardStyle(
                    backgroundColor: AppColors.ledOff,
                    borderColor: AppColors.ledOff,
                    shadowColor: AppColors.ledOff,
                    backgroundOpacity: 0.06,
                    borderOpacity: 0.2,
                    shadowOpacity: 0.12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Distribución ON/OFF',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _Bar(
                        label: 'ON',
                        value: onCount,
                        total: events.length,
                        color: AppColors.ledOn,
                        trackColor: AppColors.purpleMid,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _Bar(
                        label: 'OFF',
                        value: offCount,
                        total: events.length,
                        color: AppColors.ledOff,
                        trackColor: AppColors.purpleMid,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tabla de eventos recientes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Hora')),
                      DataColumn(label: Text('Acción')),
                      DataColumn(label: Text('Plataforma')),
                      DataColumn(label: Text('Latencia')),
                      DataColumn(label: Text('Confirmado')),
                    ],
                    rows: events.take(10).map((event) {
                      return DataRow(
                        cells: [
                          DataCell(Text(DateFormatter.time(event.createdAt))),
                          DataCell(Text(event.action)),
                          DataCell(Text(event.platform)),
                          DataCell(Text('${event.latencyMs}ms')),
                          DataCell(Text(event.confirmed ? 'Sí' : 'No')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    required this.trackColor,
    required this.labelStyle,
  });

  final String label;
  final int value;
  final int total;
  final Color color;
  final Color trackColor;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : value / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label · ${(percent * 100).round()}%', style: labelStyle),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percent,
            color: color,
            backgroundColor: trackColor,
            minHeight: 14,
          ),
        ),
      ],
    );
  }
}
