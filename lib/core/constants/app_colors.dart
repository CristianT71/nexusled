import 'package:flutter/material.dart';

class AppColors {
  // Dark tech gradient base: Dark blue to black
  static const bgPrimary = Color(0xFF0A1128); // Very dark blue
  static const bgSecondary = Color(0xFF0F1629); // Dark blue-black
  static const deepBlue = Color(0xFF0D1B2A); // Deep tech blue
  static const accentBlue = Color(0xFF1E3A5F); // Medium tech blue
  static const brightBlue = Color(0xFF2563EB); // Electric blue
  static const neonBlue = Color(0xFF00D9FF); // Neon cyan-blue
  static const accentGlow = Color(0xFF0EA5E9); // Sky blue glow

  // Kept utility colors
  static const cyanGlow = Color(0xFF06B6D4); // Cyan accent
  static const blueElectric = Color(0xFF3B82F6); // Electric blue
  static const magenta = Color(0xFF00D9FF); // Neon accent

  // Text hierarchy (adjusted for dark tech)
  static const textPrimary = Color(0xFFF0F4F8); // Light blue-white
  static const textSecondary = Color(0xFF94A9C9); // Muted blue-gray
  static const textMuted = Color(0xFF64748B); // Gray-blue

  // LED state indicators
  static const ledOn = Color(0xFF10B981); // Emerald green
  static const ledOff = Color(0xFFEF4444); // Red
  static const ledConnecting = Color(0xFFFBBF24); // Amber
  static const ledUnknown = Color(0xFF6B7280); // Gray

  // Alias for compatibility (replaces old purple references)
  static const purpleDeep = deepBlue;
  static const purpleMid = accentBlue;
  static const purpleAccent = brightBlue;
  static const purpleBright = neonBlue;
  static const purpleGlow = accentGlow;
}
