import 'package:flutter/material.dart';

import 'nexus_visual_styles.dart';

class NexusButton extends StatelessWidget {
  const NexusButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.colors,
    this.style = const NexusButtonStyle(),
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final List<Color>? colors;
  final NexusButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = colors == null
        ? style
        : style.copyWith(gradientColors: colors);
    final baseTextStyle = const TextStyle(
      fontWeight: FontWeight.w800,
      letterSpacing: 0.8,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: effectiveStyle.gradientColors),
        borderRadius: BorderRadius.circular(effectiveStyle.borderRadius),
        border: effectiveStyle.borderWidth > 0 &&
                effectiveStyle.borderColor != null
            ? Border.all(
                color: effectiveStyle.borderColor!,
                width: effectiveStyle.borderWidth,
              )
            : null,
        boxShadow: effectiveStyle.shadowBlurRadius > 0
            ? [
                BoxShadow(
                  color: (effectiveStyle.shadowColor ??
                          effectiveStyle.gradientColors.first)
                      .withValues(alpha: effectiveStyle.shadowOpacity),
                  blurRadius: effectiveStyle.shadowBlurRadius,
                  offset: effectiveStyle.shadowOffset,
                ),
              ]
            : const [],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.bolt_rounded),
        label: Text(
          label,
          style: baseTextStyle.merge(effectiveStyle.textStyle),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: effectiveStyle.foregroundColor,
          padding: effectiveStyle.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveStyle.borderRadius),
          ),
        ),
      ),
    );
  }
}
