import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../common/glass_card.dart';
import '../common/nexus_visual_styles.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppColors.purpleGlow,
    this.cardStyle = const GlassCardStyle(),
    this.titleStyle,
    this.valueStyle,
    this.iconSize = 30,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final GlassCardStyle cardStyle;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      style: cardStyle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: iconSize),
          const SizedBox(height: 18),
          Text(
            value,
            style: valueStyle ??
                const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: titleStyle ??
                const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
