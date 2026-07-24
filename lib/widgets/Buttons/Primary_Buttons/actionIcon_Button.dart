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
    required this.containerColor,
    this.iconSize = AppSizes.icon,
    required this.iconColor,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final Color containerColor;
  final double iconSize;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
