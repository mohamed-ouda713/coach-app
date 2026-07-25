import 'package:flutter/material.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/context_extensions.dart';

enum StatCardSize { small, large }

/// بطاقة رقم/إحصائية — نسخة صغيرة (شرائح الإحصاء بأعلى قائمة العملاء)
/// ونسخة كبيرة (بطاقة العمر/الوزن/الطول بملف العميلة).
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.size = StatCardSize.large,
    this.valueColor,
    this.backgroundColor,
  });

  final String value;
  final String label;
  final StatCardSize size;
  final Color? valueColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;
    final numberStyle = size == StatCardSize.small ? AppTextStyles.h3 : AppTextStyles.h4;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.mdLg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? appColors.bgSubtle,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: numberStyle.copyWith(color: valueColor ?? colorScheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs / 2),
          Text(label, style: AppTextStyles.tiny.copyWith(color: appColors.textSecondary)),
        ],
      ),
    );
  }
}
