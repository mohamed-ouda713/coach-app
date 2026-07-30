import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class CustomTextLink extends StatelessWidget {
  const CustomTextLink({
    super.key,
    this.color,
    required this.title,
    this.icon,
    this.onPressed,
    required this.textButton,
    this.textColor,
    this.iconColor,
    this.textButtonColor,
  });
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final String title;
  final String textButton;
  final IconData? icon;
  final Color? textButtonColor;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).colorScheme.primary;
    final effectiveTextButtonColor = textButtonColor ?? defaultColor;
    final effectiveTextColor = textColor ?? defaultColor;
    final effectiveIconColor = iconColor ?? defaultColor;
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textButton,
            style: AppTextStyles.buttonM.copyWith(
              color: effectiveTextButtonColor,
            ),
          ),

          const SizedBox(width: AppSpacing.xs),
          Text(
            title,
            style: AppTextStyles.buttonM.copyWith(color: effectiveTextColor),
          ),
          const SizedBox(width: AppSpacing.xs),

          if (icon != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(icon, color: effectiveIconColor, size: AppSizes.icon),
          ],
        ],
      ),
    );
  }
}
