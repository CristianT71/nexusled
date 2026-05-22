import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/led_event_model.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';
import '../../widgets/dashboard/stat_card.dart';

String formatDurationLabel(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}

class DashboardCarousel extends StatefulWidget {
  const DashboardCarousel({
    super.key,
    required this.ledOn,
    required this.ledColor,
    required this.events,
    required this.latencyMs,
    required this.stateSince,
  });

  final bool ledOn;
  final String ledColor;
  final List<LedEventModel> events;
  final int latencyMs;
  final DateTime stateSince;

  @override
  State<DashboardCarousel> createState() => _DashboardCarouselState();
}

class _DashboardCarouselState extends State<DashboardCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _pageIndex = 0;

  static const _pagesCount = 4;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final nextPage = (_pageIndex + 1) % _pagesCount;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NexusLED Live',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Desliza solo entre resúmenes clave de tu sistema.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 144,
            child: PageView(
              controller: _controller,
              onPageChanged: (index) => setState(() => _pageIndex = index),
              children: [
                _CarouselPanel(
                  icon: widget.ledOn
                      ? Icons.lightbulb
                      : Icons.lightbulb_outline,
                  title: 'Estado actual',
                  value: widget.ledOn ? widget.ledColor.toUpperCase() : 'Apagado',
                  subtitle: formatDurationLabel(
                    DateTime.now().difference(widget.stateSince),
                  ),
                  accent: _getColorValue(widget.ledColor),
                ),
                _CarouselPanel(
                  icon: Icons.speed_rounded,
                  title: 'Latencia de respuesta',
                  value: '${widget.latencyMs} ms',
                  subtitle: widget.latencyMs < 100
                      ? 'Dentro del rango ideal para control en tiempo real.'
                      : 'Conviene revisar red o broker si sigue alta.',
                  accent: widget.latencyMs < 100
                      ? AppColors.ledOn
                      : AppColors.ledConnecting,
                ),
                _CarouselPanel(
                  icon: Icons.receipt_long_rounded,
                  title: 'Actividad reciente',
                  value: '${widget.events.length} eventos',
                  subtitle: widget.events.isEmpty
                      ? 'Todavía no hay registros en la sesión actual.'
                      : 'Último cambio: ${widget.events.first.newState}',
                  accent: AppColors.cyanGlow,
                ),
                _CarouselPanel(
                  icon: Icons.access_time_rounded,
                  title: 'Tiempo en estado',
                  value: formatDurationLabel(
                    DateTime.now().difference(widget.stateSince),
                  ),
                  subtitle: widget.ledOn
                      ? 'El LED lleva encendido este tiempo.'
                      : 'El LED permanece apagado desde entonces.',
                  accent: AppColors.blueElectric,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pagesCount, (index) {
              final active = index == _pageIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: active ? 22 : 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.brightBlue
                      : AppColors.textSecondary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CarouselPanel extends StatelessWidget {
  const _CarouselPanel({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.28),
            AppColors.bgSecondary.withValues(alpha: 0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.ledOn,
    required this.ledColor,
    required this.events,
    required this.latencyMs,
    required this.stateSince,
    required this.onOpenControl,
  });

  final bool ledOn;
  final String ledColor;
  final List<LedEventModel> events;
  final int latencyMs;
  final DateTime stateSince;
  final VoidCallback onOpenControl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardCarousel(
            ledOn: ledOn,
            ledColor: ledColor,
            events: events,
            latencyMs: latencyMs,
            stateSince: stateSince,
          ),
          const SizedBox(height: 24),

          // KPIs
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 250,
                child: StatCard(
                  title: 'Color LED',
                  value: ledOn ? ledColor.toUpperCase() : 'APAGADO',
                  icon: Icons.lightbulb_rounded,
                  color: _getColorValue(ledColor),
                ),
              ),
              SizedBox(
                width: 250,
                child: StatCard(
                  title: 'Eventos hoy',
                  value: '${events.length}',
                  icon: Icons.bolt_rounded,
                  color: AppColors.cyanGlow,
                ),
              ),
              SizedBox(
                width: 250,
                child: StatCard(
                  title: 'Tiempo de estado',
                  value: formatDurationLabel(
                    DateTime.now().difference(stateSince),
                  ),
                  icon: Icons.timer_rounded,
                  color: AppColors.blueElectric,
                ),
              ),
              SizedBox(
                width: 250,
                child: StatCard(
                  title: 'Latencia MQTT',
                  value: '${latencyMs}ms',
                  icon: Icons.speed_rounded,
                  color: latencyMs < 100
                      ? AppColors.ledOn
                      : AppColors.ledConnecting,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 1. GRÁFICO DE BARRAS (Actividad por hora)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Gráfico de Barras: Actividad por Hora (24h)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: 15,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${(value.toInt()) % 24}h',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: _generateBarData(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. GRÁFICO CIRCULAR (Distribución de eventos)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🥧 Gráfico Circular: Distribución de Colores RGB',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 40,
                      sections: _generatePieData(),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. GRÁFICO DE LÍNEAS (Tendencia de latencia)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📈 Gráfico de Líneas: Tendencia de Latencia (ms)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 50,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}ms',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                'h${value.toInt()}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateLatencyTrend(),
                          isCurved: true,
                          color: AppColors.brightBlue,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.brightBlue.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. HISTOGRAMA (Distribución de latencia)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Histograma: Distribución de Latencia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceEvenly,
                      maxY: 20,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final ranges = [
                                '0-50',
                                '51-100',
                                '101-150',
                                '151-200',
                                '200+',
                              ];
                              return Text(
                                ranges[value.toInt()],
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: _generateHistogramData(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 5. DIAGRAMA DE DISPERSIÓN (Scatter: Hora vs Latencia)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🔵 Diagrama de Dispersión: Hora vs Latencia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: ScatterChart(
                    ScatterChartData(
                      scatterSpots: _generateScatterData(),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 50,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}ms',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}h',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: const FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 24,
                      minY: 0,
                      maxY: 250,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 6. DIAGRAMA DE CAJA Y BIGOTES (Box Plot)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📦 Diagrama de Caja y Bigotes (Latencia)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildBoxPlot(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Control rápido
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Control Rápido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Text(
                  'Estado actual: ${ledOn ? '🟢 ${ledColor.toUpperCase()}' : '🔴 APAGADO'}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 18),
                NexusButton(
                  label: 'IR A CONTROL LED',
                  onPressed: onOpenControl,
                  icon: Icons.lightbulb_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Datos para gráfico de barras
  List<BarChartGroupData> _generateBarData() {
    return List.generate(24, (i) {
      final random = (i * 7) % 15 + (i % 3);
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: random.toDouble(),
            color: AppColors.brightBlue,
            width: 6,
          ),
        ],
      );
    });
  }

  // Datos para gráfico circular
  List<PieChartSectionData> _generatePieData() {
    final redCount = events.where((e) => e.color == 'red').length;
    final greenCount = events.where((e) => e.color == 'green').length;
    final blueCount = events.where((e) => e.color == 'blue').length;
    final offCount = events.where((e) => e.color == 'off').length;
    final total = redCount + greenCount + blueCount + offCount;

    return [
      PieChartSectionData(
        color: Colors.red,
        value: total > 0 ? (redCount / total) * 100 : 25,
        title: 'RED: $redCount',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: total > 0 ? (greenCount / total) * 100 : 25,
        title: 'GREEN: $greenCount',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: total > 0 ? (blueCount / total) * 100 : 25,
        title: 'BLUE: $blueCount',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.grey,
        value: total > 0 ? (offCount / total) * 100 : 25,
        title: 'OFF: $offCount',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ];
  }

  // Datos para gráfico de líneas (tendencia)
  List<FlSpot> _generateLatencyTrend() {
    return List.generate(24, (i) {
      final baseLatency = 50 + (i * 5) % 100;
      final variance = (i % 3) * 10;
      return FlSpot(i.toDouble(), (baseLatency + variance).toDouble());
    });
  }

  // Datos para histograma
  List<BarChartGroupData> _generateHistogramData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 12, color: AppColors.neonBlue)],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 18, color: AppColors.neonBlue)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 8, color: AppColors.neonBlue)],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: 5, color: AppColors.neonBlue)],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [BarChartRodData(toY: 2, color: AppColors.neonBlue)],
      ),
    ];
  }

  // Datos para scatter plot
  List<ScatterSpot> _generateScatterData() {
    return List.generate(24, (i) {
      final latency = 50 + (i * 5) % 100 + (i % 3) * 10;
      return ScatterSpot(i.toDouble(), latency.toDouble());
    });
  }

  // Box plot custom
  Widget _buildBoxPlot() {
    final stats = _calculateStats();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBox(
            'Latencia (ms)',
            stats['min']!,
            stats['q1']!,
            stats['median']!,
            stats['q3']!,
            stats['max']!,
          ),
        ],
      ),
    );
  }

  Widget _buildBox(
    String label,
    double min,
    double q1,
    double median,
    double q3,
    double max,
  ) {
    final scale = 200.0 / max;
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Línea de min
            Container(height: 2, width: 20, color: AppColors.textSecondary),
            const SizedBox(width: 2),
            // Bigote
            Container(height: 40, width: 2, color: AppColors.textSecondary),
            const SizedBox(width: 2),
            // Caja
            Container(
              width: ((q3 - q1) * scale).clamp(40, double.infinity),
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brightBlue, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  // Mediana
                  Positioned(
                    left: ((median - q1) * scale).clamp(0, ((q3 - q1) * scale)),
                    child: Container(
                      width: 2,
                      height: 40,
                      color: AppColors.ledOn,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),
            // Bigote
            Container(height: 40, width: 2, color: AppColors.textSecondary),
            const SizedBox(width: 2),
            // Línea de max
            Container(height: 2, width: 20, color: AppColors.textSecondary),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Min: ${min.toStringAsFixed(0)}, Q1: ${q1.toStringAsFixed(0)}, Med: ${median.toStringAsFixed(0)}, Q3: ${q3.toStringAsFixed(0)}, Max: ${max.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Calcular estadísticas para box plot
  Map<String, double> _calculateStats() {
    final latencies = events.map((e) => e.latencyMs.toDouble()).toList();
    if (latencies.isEmpty) {
      return {'min': 0, 'q1': 25, 'median': 50, 'q3': 75, 'max': 100};
    }
    latencies.sort();
    final n = latencies.length;
    return {
      'min': latencies.first,
      'q1': latencies[(n * 0.25).toInt()],
      'median': latencies[(n * 0.5).toInt()],
      'q3': latencies[(n * 0.75).toInt()],
      'max': latencies.last,
    };
  }

  Color _getColorValue(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      default:
        return AppColors.ledOff;
    }
  }
}
