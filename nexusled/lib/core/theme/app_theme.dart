import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purpleBright,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Segoe UI',
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.brightBlue.withValues(alpha: 0.06),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.accentGlow,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.brightBlue.withValues(alpha: 0.22),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accentGlow),
        ),
      ),
    );
  }
}
