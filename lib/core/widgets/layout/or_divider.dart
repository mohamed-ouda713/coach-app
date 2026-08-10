import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppColorsDark.textSecondary;
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            AppStrings.dividerOr,
            style: AppTextStyles.bodyM.copyWith(color: dividerColor),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}
