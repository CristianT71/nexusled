import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/common/animated_background.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/common/nexus_visual_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _LogoMark(
                  outerColors: [AppColors.brightBlue, AppColors.accentGlow],
                  glowColor: AppColors.accentGlow,
                  innerBackgroundColor: AppColors.bgPrimary,
                  innerBackgroundOpacity: 0.8,
                  innerBorderColor: Colors.white,
                  innerBorderOpacity: 0.08,
                  iconColor: Colors.white,
                ),
                const SizedBox(height: 22),
                Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    color: AppColors.textPrimary,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bienvenido al sistema',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 26),
                GlassCard(
                  padding: const EdgeInsets.all(18),
                  style: const GlassCardStyle(
                    backgroundColor: AppColors.bgSecondary,
                    backgroundOpacity: 0.72,
                    borderColor: AppColors.purpleGlow,
                    borderOpacity: 0.18,
                    shadowColor: AppColors.accentGlow,
                    shadowOpacity: 0.12,
                    borderRadius: 20,
                  ),
                  child: const Column(
                    children: [
                      LinearProgressIndicator(
                        color: AppColors.accentGlow,
                        backgroundColor: AppColors.accentBlue,
                        minHeight: 7,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Preparando tu panel de control',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark({
    required this.outerColors,
    required this.glowColor,
    required this.innerBackgroundColor,
    required this.innerBackgroundOpacity,
    required this.innerBorderColor,
    required this.innerBorderOpacity,
    required this.iconColor,
  });

  final List<Color> outerColors;
  final Color glowColor;
  final Color innerBackgroundColor;
  final double innerBackgroundOpacity;
  final Color innerBorderColor;
  final double innerBorderOpacity;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: outerColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.45),
            blurRadius: 42,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: innerBackgroundColor.withValues(alpha: innerBackgroundOpacity),
          border: Border.all(
            color: innerBorderColor.withValues(alpha: innerBorderOpacity),
          ),
        ),
        child: Icon(Icons.bolt_rounded, size: 68, color: iconColor),
      ),
    );
  }
}
