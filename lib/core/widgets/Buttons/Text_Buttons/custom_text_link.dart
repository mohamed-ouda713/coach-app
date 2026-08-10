import 'package:flutter/material.dart';
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
    this.textButton = '',
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
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min, // 👈 يمنع الزر من أخذ مساحة أكبر من محتواه
        children: [if (icon != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(icon, color: effectiveIconColor, size: AppSizes.icon),
          ],
          // 1. النص الفرعي (إن وجد)
          if (textButton.isNotEmpty) ...[
            Text(
              textButton,
              style: AppTextStyles.buttonM.copyWith(
                color: effectiveTextButtonColor,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],

          // 2. العنوان الرئيسي
          Text(
            title,
            style: AppTextStyles.buttonM.copyWith(color: effectiveTextColor),
          ),

          // 3. الأيقونة (تأتي بعد النص بدون SizedBox قيادي في البداية)
          
        ],
      ),
    );
  }
}