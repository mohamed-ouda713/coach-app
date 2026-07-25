import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.title,
     this.backgroundColor,
    this.onTap,
     this.textColor,
  });
  final String title;
  final Color? backgroundColor;
  final void Function()? onTap;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? theme.colorScheme.onPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
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
