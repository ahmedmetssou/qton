import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final double radius;
  final Color? color;
  final double blur;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
    this.color,
    this.blur = 10,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? AppConstants.cardColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(radius),
            border:
                border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double radius;
  final EdgeInsets padding;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.radius = 16,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
