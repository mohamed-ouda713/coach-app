import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_borders.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.title,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
  });

  final String title;
  final String hintText;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    // جلب الألوان بأمان من ثيم النظام مباشرة لتجنب أخطاء الـ Null
    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;
    final primaryColor = theme.colorScheme.primary;
    final textSecondaryColor = theme.hintColor;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyM.copyWith(color: textSecondaryColor),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.mdLg,
              vertical: AppSpacing.xl,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            labelText: label,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: primaryColor,
                width: AppBorders.regular,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
