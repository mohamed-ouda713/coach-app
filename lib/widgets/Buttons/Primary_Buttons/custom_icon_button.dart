import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.color,
    required this.iconColor,
  });
  final IconData icon;
  final void Function()? onPressed;
  final Color color;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(AppSpacing.md),
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
      ),
    );
  }
}
