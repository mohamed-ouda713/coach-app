import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
     this.color,
     this.iconColor,
  });
  final IconData icon;
  final void Function()? onPressed;
  final Color? color;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.surfaceContainerHigh;
    final effectiveIconColor = iconColor ?? theme.colorScheme.onSurface;
    return Ink(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(AppSpacing.md),
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: Icon(icon, color: effectiveIconColor),
      ),
    );
  }
}
