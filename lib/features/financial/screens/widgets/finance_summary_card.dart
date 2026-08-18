// lib/features/financial/screens/widgets/finance_summary_card.dart

import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import '../../helper/finance_formatters.dart';

/// بطاقة إحصائية بأعلى شاشة المالية — تسمية فوق، رقم كبير بالنص،
/// ووحدة "ريال" تحت. تُستخدم لصافي الربح، المصروفات، والدخل.
class FinanceSummaryCard extends StatelessWidget {
  const FinanceSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  final String label;
  final double value;
  final Color backgroundColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.mdLg,
        vertical: AppSpacing.lgAlt,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.cardLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyS.copyWith(color: valueColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            FinanceFormatters.number(value),
            style: AppTextStyles.h2.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs / 2),
          Text(
            AppStrings.financeCurrency,
            style: AppTextStyles.tiny.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}