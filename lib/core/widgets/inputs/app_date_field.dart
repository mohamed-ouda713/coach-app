// lib/core/widgets/inputs/app_date_field.dart

import 'package:flutter/material.dart';
import '../../constants/app_borders.dart';
import '../../constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:intl/intl.dart';

/// حقل اختيار تاريخ (يفتح [showDatePicker] بمكان الاستخدام عبر [onTap])
/// — بنفس شكل حقول الفورم بالتطبيق. لو [date] فاضي بيعرض [placeholder].
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
    required this.dateFormat,
    this.placeholder = 'dd / mm / yyyy',
    this.highlighted = false,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final DateFormat dateFormat;
  final String placeholder;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;
    final hasValue = date != null;
    final isHighlighted = highlighted && hasValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyS.copyWith(color: appColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: AppSizes.inputHeightSm,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mdLg),
            decoration: BoxDecoration(
              color:
                  isHighlighted
                      ? appColors.primarySoftBg
                      : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isHighlighted ? primary : appColors.border,
                width: AppBorders.regular,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppSizes.iconXs,
                  color: isHighlighted ? primary : appColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.smMd),
                Text(
                  hasValue ? dateFormat.format(date!) : placeholder,
                  style: AppTextStyles.bodyS.copyWith(
                    fontWeight:
                        isHighlighted ? FontWeight.w600 : FontWeight.w400,
                    // تاريخ متعبّى بياخد لون النص الأساسي زي باقي الحقول.
                    // كان بياخد textTertiary دايمًا، فالقيمة المكتوبة كانت
                    // تبين باهتة زي الـ placeholder ومحدا يفرق بينهم.
                    color:
                        isHighlighted
                            ? primary
                            : hasValue
                            ? Theme.of(context).colorScheme.onSurface
                            : appColors.textTertiary,
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
