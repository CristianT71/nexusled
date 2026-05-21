import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/common/animated_background.dart';

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
                const _LogoMark(),
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
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.purpleGlow.withValues(alpha: 0.18),
                    ),
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
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.brightBlue, AppColors.accentGlow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.45),
            blurRadius: 42,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bgPrimary.withValues(alpha: 0.8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: const Icon(Icons.bolt_rounded, size: 68, color: Colors.white),
      ),
    );
  }
}
