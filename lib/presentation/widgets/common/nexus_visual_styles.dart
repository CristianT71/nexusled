import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

@immutable
class GlassCardStyle {
  const GlassCardStyle({
    this.backgroundColor = AppColors.purpleBright,
    this.backgroundOpacity = 0.08,
    this.borderColor = AppColors.colorTarjetaAbout,
    this.borderOpacity = 0.25,
    this.borderWidth = 1,
    this.borderRadius = 24,
    this.shadowColor = AppColors.purpleBright,
    this.shadowOpacity = 0.14,
    this.shadowBlurRadius = 26,
    this.shadowOffset = const Offset(0, 10),
    this.blurSigmaX = 12,
    this.blurSigmaY = 12,
  });

  final Color backgroundColor;
  final double backgroundOpacity;
  final Color borderColor;
  final double borderOpacity;
  final double borderWidth;
  final double borderRadius;
  final Color shadowColor;
  final double shadowOpacity;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final double blurSigmaX;
  final double blurSigmaY;

  GlassCardStyle copyWith({
    Color? backgroundColor,
    double? backgroundOpacity,
    Color? borderColor,
    double? borderOpacity,
    double? borderWidth,
    double? borderRadius,
    Color? shadowColor,
    double? shadowOpacity,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    double? blurSigmaX,
    double? blurSigmaY,
  }) {
    return GlassCardStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      borderColor: borderColor ?? this.borderColor,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      blurSigmaX: blurSigmaX ?? this.blurSigmaX,
      blurSigmaY: blurSigmaY ?? this.blurSigmaY,
    );
  }
}

@immutable
class NexusButtonStyle {
  const NexusButtonStyle({
    this.gradientColors = const [
      AppColors.purpleAccent,
      AppColors.purpleBright,
    ],
    this.foregroundColor = Colors.white,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
    this.shadowColor,
    this.shadowOpacity = 0.35,
    this.shadowBlurRadius = 22,
    this.shadowOffset = Offset.zero,
    this.borderColor,
    this.borderWidth = 0,
    this.textStyle,
  });

  final List<Color> gradientColors;
  final Color foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? shadowColor;
  final double shadowOpacity;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final Color? borderColor;
  final double borderWidth;
  final TextStyle? textStyle;

  NexusButtonStyle copyWith({
    List<Color>? gradientColors,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    Color? shadowColor,
    double? shadowOpacity,
    double? shadowBlurRadius,
    Offset? shadowOffset,
    Color? borderColor,
    double? borderWidth,
    TextStyle? textStyle,
  }) {
    return NexusButtonStyle(
      gradientColors: gradientColors ?? this.gradientColors,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}

@immutable
class TopBarStyle {
  const TopBarStyle({
    this.backgroundColor = AppColors.purpleDeep,
    this.backgroundOpacity = 0.62,
    this.borderColor = AppColors.purpleBright,
    this.borderOpacity = 0.18,
    this.notificationBadgeColor = AppColors.magenta,
    this.profileAvatarColor = AppColors.purpleAccent,
  });

  final Color backgroundColor;
  final double backgroundOpacity;
  final Color borderColor;
  final double borderOpacity;
  final Color notificationBadgeColor;
  final Color profileAvatarColor;

  TopBarStyle copyWith({
    Color? backgroundColor,
    double? backgroundOpacity,
    Color? borderColor,
    double? borderOpacity,
    Color? notificationBadgeColor,
    Color? profileAvatarColor,
  }) {
    return TopBarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      borderColor: borderColor ?? this.borderColor,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      notificationBadgeColor:
          notificationBadgeColor ?? this.notificationBadgeColor,
      profileAvatarColor: profileAvatarColor ?? this.profileAvatarColor,
    );
  }
}

@immutable
class SidebarStyle {
  const SidebarStyle({
    this.backgroundColor = AppColors.purpleDeep,
    this.backgroundOpacity = 0.92,
    this.borderColor = AppColors.purpleBright,
    this.borderOpacity = 0.22,
    this.activeItemBackgroundColor = AppColors.purpleBright,
    this.activeItemBackgroundOpacity = 0.16,
    this.activeIndicatorColor = AppColors.purpleGlow,
    this.accentColor = AppColors.purpleGlow,
    this.activeTextColor = AppColors.textPrimary,
    this.inactiveTextColor = AppColors.textSecondary,
    this.inactiveIconColor = AppColors.textMuted,
    this.sectionLabelColor = AppColors.textMuted,
    this.avatarBackgroundColor = AppColors.purpleAccent,
  });

  final Color backgroundColor;
  final double backgroundOpacity;
  final Color borderColor;
  final double borderOpacity;
  final Color activeItemBackgroundColor;
  final double activeItemBackgroundOpacity;
  final Color activeIndicatorColor;
  final Color accentColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color inactiveIconColor;
  final Color sectionLabelColor;
  final Color avatarBackgroundColor;

  SidebarStyle copyWith({
    Color? backgroundColor,
    double? backgroundOpacity,
    Color? borderColor,
    double? borderOpacity,
    Color? activeItemBackgroundColor,
    double? activeItemBackgroundOpacity,
    Color? activeIndicatorColor,
    Color? accentColor,
    Color? activeTextColor,
    Color? inactiveTextColor,
    Color? inactiveIconColor,
    Color? sectionLabelColor,
    Color? avatarBackgroundColor,
  }) {
    return SidebarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      borderColor: borderColor ?? this.borderColor,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      activeItemBackgroundColor:
          activeItemBackgroundColor ?? this.activeItemBackgroundColor,
      activeItemBackgroundOpacity:
          activeItemBackgroundOpacity ?? this.activeItemBackgroundOpacity,
      activeIndicatorColor:
          activeIndicatorColor ?? this.activeIndicatorColor,
      accentColor: accentColor ?? this.accentColor,
      activeTextColor: activeTextColor ?? this.activeTextColor,
      inactiveTextColor: inactiveTextColor ?? this.inactiveTextColor,
      inactiveIconColor: inactiveIconColor ?? this.inactiveIconColor,
      sectionLabelColor: sectionLabelColor ?? this.sectionLabelColor,
      avatarBackgroundColor:
          avatarBackgroundColor ?? this.avatarBackgroundColor,
    );
  }
}

@immutable
class NexusBadgeStyle {
  const NexusBadgeStyle({
    this.backgroundColor = AppColors.brightBlue,
    this.backgroundOpacity = 0.15,
    this.borderColor = AppColors.brightBlue,
    this.borderOpacity = 0.3,
    this.borderRadius = 16,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.iconColor = AppColors.brightBlue,
    this.labelStyle = const TextStyle(
      color: AppColors.brightBlue,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
  });

  final Color backgroundColor;
  final double backgroundOpacity;
  final Color borderColor;
  final double borderOpacity;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final Color iconColor;
  final TextStyle labelStyle;

  NexusBadgeStyle copyWith({
    Color? backgroundColor,
    double? backgroundOpacity,
    Color? borderColor,
    double? borderOpacity,
    double? borderRadius,
    double? borderWidth,
    EdgeInsetsGeometry? padding,
    Color? iconColor,
    TextStyle? labelStyle,
  }) {
    return NexusBadgeStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      borderColor: borderColor ?? this.borderColor,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      iconColor: iconColor ?? this.iconColor,
      labelStyle: labelStyle ?? this.labelStyle,
    );
  }
}

@immutable
class NexusInfoTileStyle {
  const NexusInfoTileStyle({
    this.iconColor = AppColors.accentGlow,
    this.titleStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.brightBlue,
    ),
    this.descriptionStyle = const TextStyle(
      color: AppColors.textSecondary,
      fontSize: 13,
    ),
    this.iconSize = 24,
    this.gap = 12,
    this.bottomPadding = 12,
  });

  final Color iconColor;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final double iconSize;
  final double gap;
  final double bottomPadding;

  NexusInfoTileStyle copyWith({
    Color? iconColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    double? iconSize,
    double? gap,
    double? bottomPadding,
  }) {
    return NexusInfoTileStyle(
      iconColor: iconColor ?? this.iconColor,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      iconSize: iconSize ?? this.iconSize,
      gap: gap ?? this.gap,
      bottomPadding: bottomPadding ?? this.bottomPadding,
    );
  }
}
