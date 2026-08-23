import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_borders.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class SelectedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;

  const SelectedButton({
    super.key,
    required this.title,
    this.onTap,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderColor = borderColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? theme.colorScheme.primary;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHigh;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: effectiveBorderColor,
            width: AppBorders.regular,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.buttonM.copyWith(color: effectiveTextColor),
        ),
      ),
    );
  }
}
