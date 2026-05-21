import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../common/glass_card.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppColors.purpleGlow,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
