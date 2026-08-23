import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';

class ActionIconButton extends StatelessWidget {
  const ActionIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.containerColor,
    this.iconSize = AppSizes.icon,
    this.iconColor,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? containerColor;
  final double iconSize;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveContainerColor =
        containerColor ?? theme.colorScheme.surfaceContainerHigh;
    final effectiveIconColor = iconColor ?? theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: effectiveContainerColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize, color: effectiveIconColor),
      ),
    );
  }
}
