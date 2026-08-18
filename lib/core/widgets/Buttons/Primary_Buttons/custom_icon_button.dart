import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.iconColor,
    this.size = 40.0,
    this.iconSize = 20.0,
  });

  final IconData icon;
  final void Function()? onPressed;
  final Color? color;
  final Color? iconColor;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.surfaceContainerHigh;
    final effectiveIconColor = iconColor ?? theme.colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: effectiveIconColor,
            ),
          ),
        ),
      ),
    );
  }
}