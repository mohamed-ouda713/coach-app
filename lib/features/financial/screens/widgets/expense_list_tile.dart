// lib/features/financial/screens/widgets/expense_list_tile.dart

import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import '../../helper/finance_formatters.dart';
import '../../models/transaction_model.dart';

/// سطر مصروف واحد بقائمة "المصروفات" — الوصف بجهة، والمبلغ + التاريخ
/// بالجهة التانية، بنفس نمط بطاقات التطبيق (خلفية بيضاء + ظل خفيف).
class ExpenseListTile extends StatelessWidget {
  const ExpenseListTile({super.key, required this.expense});

  final TransactionModel expense;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lgAlt,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.cardLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FinanceFormatters.currency(expense.amount),
                style: AppTextStyles.h5.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs / 2),
              Text(
                FinanceFormatters.dayMonth(expense.date),
                style: AppTextStyles.caption.copyWith(
                  color: appColors.textTertiary,
                ),
              ),
            ],
          ),
          Text(
            expense.description,
            style: AppTextStyles.bodyM.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
