import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.color});

  /// لون اختياري للخط والنص. الافتراضي بيجي من الثيم — قبل هيك كان
  /// ثابت على لون من البالِت الداكنة، فبالوضع الفاتح كان الفاصل أبيض
  /// تقريبًا على بطاقة بيضا ومش باين.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final lineColor = color ?? appColors.border;
    final labelColor = color ?? appColors.textSecondary;

    return Row(
      children: [
        Expanded(child: Divider(color: lineColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            AppStrings.dividerOr,
            style: AppTextStyles.bodyM.copyWith(color: labelColor),
          ),
        ),
        Expanded(child: Divider(color: lineColor, thickness: 1)),
      ],
    );
  }
}
