import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glow_up/core/constants/app_borders.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class AddDate extends StatelessWidget {
  const AddDate({
    super.key,
    required this.title,
    required this.label,
    this.icon,
  });
  final String title;
  final String label;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyM.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.cardLg),
            color: colors.bgSubtle,
            border: Border.all(color: primaryColor, width: AppBorders.regular),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyM.copyWith(color: primaryColor),
                ),
                const SizedBox(height: AppSpacing.smMd),
                Icon(icon, color: primaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
