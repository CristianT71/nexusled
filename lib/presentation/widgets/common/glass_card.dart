import 'dart:ui';

import 'package:flutter/material.dart';

import 'nexus_visual_styles.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.style = const GlassCardStyle(),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final GlassCardStyle style;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(style.borderRadius);
    final content = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: style.blurSigmaX,
          sigmaY: style.blurSigmaY,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: style.backgroundColor.withValues(alpha: style.backgroundOpacity),
            borderRadius: radius,
            border: Border.all(
              color: style.borderColor.withValues(alpha: style.borderOpacity),
              width: style.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: style.shadowColor.withValues(alpha: style.shadowOpacity),
                blurRadius: style.shadowBlurRadius,
                offset: style.shadowOffset,
              ),
            ],
          ),
          child: Material(color: Colors.transparent, child: child),
        ),
      ),
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, borderRadius: radius, child: content);
  }
}
