// lib/features/financial/screens/financial_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/custom_icon_button.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_view.dart';

import '../cubit/financial_cubit.dart';
import '../cubit/financial_state.dart';
import '../models/partner_model.dart';
import 'widgets/add_expense_dialog.dart';
import 'widgets/expense_list_tile.dart';
import 'widgets/finance_summary_card.dart';
import 'widgets/partner_form_dialog.dart';
import 'widgets/partner_split_card.dart';

/// ملاحظة: هاي الشاشة بتترسم كتبويب جوا HomePage (IndexedStack)، فمالهاش
/// appBar خاص فيها — الهيدر المخصص ("المالية" + الشهر + "إضافة") بيترسم
/// من HomePage نفسها لما يكون التبويب الحالي هو المالية.
class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FinancialCubit>().loadMonth();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.appColors.bgSubtle,
      child: SafeArea(
        top: false,
        child: BlocBuilder<FinancialCubit, FinancialState>(
          builder: (context, state) {
            return switch (state) {
              FinancialInitial() || FinancialLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              FinancialError(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context.read<FinancialCubit>().loadMonth(),
                ),
              FinancialLoaded() => _FinancialContent(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _FinancialContent extends StatelessWidget {
  const _FinancialContent({required this.state});

  final FinancialLoaded state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lgAlt),
      children: [
        Row(
          children: [
            Expanded(
              child: FinanceSummaryCard(
                label: AppStrings.financeIncome,
                value: state.income,
                backgroundColor: context.appColors.successBg,
                valueColor: context.appColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: FinanceSummaryCard(
                label: AppStrings.financeExpenses,
                value: state.totalExpenses,
                backgroundColor: context.appColors.dangerBg,
                valueColor: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: FinanceSummaryCard(
                label: AppStrings.financeNetProfit,
                value: state.netProfit,
                backgroundColor: context.appColors.primarySoftBg,
                valueColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // استبدلنا _CircleAddButton المحلي (كان نسخة طبق الأصل من
            // CustomIconButton) بالويدجت الجاهز نفسه — بنفس المقاسات
            // والشكل تقريبًا، بدون تكرار كود.
            CustomIconButton(
              icon: Icons.add,
              onPressed: () => AddExpenseDialog.show(context),
              color: Theme.of(context).colorScheme.primary,
              iconColor: Theme.of(context).colorScheme.onPrimary,
              size: 40,
              iconSize: 22,
            ),
            Text(
              AppStrings.financeExpenses,
              style: AppTextStyles.h4.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.mdLg),
        if (state.expenses.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Text(
              AppStrings.financeNoExpensesMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyM.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          )
        else
          ...state.expenses.map(
            (expense) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.smMd),
              child: ExpenseListTile(expense: expense),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          AppStrings.financeProfitSplit,
          style: AppTextStyles.h4.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.mdLg),
        _PartnersCard(
          partners: state.partners,
          netProfit: state.netProfit,
        ),
      ],
    );
  }
}

class _PartnersCard extends StatelessWidget {
  const _PartnersCard({
    required this.partners,
    required this.netProfit,
  });

  final List<PartnerModel> partners;
  final double netProfit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lgAlt),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (partners.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text(
                AppStrings.financeNoPartnersMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyM.copyWith(
                  color: appColors.textSecondary,
                ),
              ),
            )
          else
            for (var i = 0; i < partners.length; i++) ...[
              PartnerSplitCard(
                partner: partners[i],
                netProfit: netProfit,
                accentColor:
                    i == 0 ? colorScheme.primary : appColors.textSecondary,
                accentBackgroundColor:
                    i == 0 ? appColors.primarySoftBg : appColors.bgSubtle,
                onEdit: () =>
                    PartnerFormDialog.show(context, partner: partners[i]),
                // سلوك السحب لسا مش محدد (بند 4) — الزر بيترسم
                // بحالة معطّلة جوا PartnerSplitCard لما onWithdraw تكون
                // null.
                onWithdraw: null,
              ),
              if (i != partners.length - 1) ...[
                const SizedBox(height: AppSpacing.lg),
                Divider(color: appColors.bgSubtle),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: InkWell(
              onTap: () => PartnerFormDialog.show(context),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.lg,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: colorScheme.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      AppStrings.financeAddNewPartner,
                      style: AppTextStyles.buttonM.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}