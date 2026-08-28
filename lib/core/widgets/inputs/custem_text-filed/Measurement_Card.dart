import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_borders.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class MeasurementCard extends StatelessWidget {
  const MeasurementCard({
    super.key,
    required this.title,
    required this.labelText,
    this.icon,
    required this.subTitle,
    required this.isSelected,
  });
  final String title;
  final String subTitle;
  final String labelText;
  final IconData? icon;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final cardBackgroundColor =
        isSelected ? appColors.primarySoftBg : appColors.bgSubtle;
    final borderColor =
        isSelected ? theme.colorScheme.primary : appColors.border;
    final titleColor =
        isSelected ? appColors.primaryOnSoftBg : theme.colorScheme.onSurface;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppTextStyles.h4.copyWith(color: appColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.cardLg),
            color: cardBackgroundColor,
            border: Border.all(color: borderColor, width: AppBorders.regular),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.h1.copyWith(color: titleColor),
                ),
                Text(
                  subTitle,
                  style: AppTextStyles.bodyM.copyWith(
                    color: appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//Selected
//non
