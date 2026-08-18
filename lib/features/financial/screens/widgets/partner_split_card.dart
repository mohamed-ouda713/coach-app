// lib/features/financial/screens/widgets/partner_split_card.dart

import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/custom_icon_button.dart';
import 'package:glow_up/core/widgets/status/badges.dart';
import '../../helper/finance_formatters.dart';
import '../../models/partner_model.dart';

/// بطاقة طرف واحد بقسمة الربح — شارة النسبة، الاسم، زر تعديل، زر سحب،
/// شريط تقدّم بلون الطرف، وسطر الرصيد المحسوب.
class PartnerSplitCard extends StatelessWidget {
  const PartnerSplitCard({
    super.key,
    required this.partner,
    required this.netProfit,
    required this.accentColor,
    required this.accentBackgroundColor,
    required this.onEdit,
    required this.onWithdraw,
  });

  final PartnerModel partner;

  /// صافي الربح الشهري (الدخل - المصاريف)
  final double netProfit;
  final Color accentColor;
  final Color accentBackgroundColor;
  final VoidCallback onEdit;
  final VoidCallback onWithdraw;

  /// حساب رصيد الشريك الحالي = (رصيده المسجل/التراكمي) + (حصة الشريك من صافي ربح الشهر)
  double get _calculatedBalance {
    final monthlyShare =
        (netProfit > 0 ? netProfit : 0.0) * (partner.sharePercentage / 100);
    return partner.balance + monthlyShare;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _WithdrawButton(onTap: onWithdraw),
            const Spacer(),
            CustomIconButton(
              icon: Icons.edit_outlined,
              onPressed: onEdit,
              color: appColors.bgSubtle,
              iconColor: appColors.textSecondary,
              size: 28,
              iconSize: 14,
            ),
            const SizedBox(width: AppSpacing.smMd),
            Text(
              partner.name,
              style: AppTextStyles.h5.copyWith(color: colorScheme.onSurface),
            ),
            const SizedBox(width: AppSpacing.xs),
            SharePercentageBadge(
              percentage: partner.sharePercentage,
              background: accentBackgroundColor,
              foreground: accentColor,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.smMd),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: (partner.sharePercentage / 100).clamp(0, 1),
            minHeight: 6,
            backgroundColor: appColors.bgSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          ),
        ),
        const SizedBox(height: AppSpacing.smMd),
        Text(
          '${AppStrings.financeBalance} ${FinanceFormatters.currency(_calculatedBalance)}',
          style: AppTextStyles.bodyS.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _WithdrawButton extends StatelessWidget {
  const _WithdrawButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: appColors.bgSubtle,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          AppStrings.financeWithdraw,
          style: AppTextStyles.buttonS.copyWith(color: appColors.textSecondary),
        ),
      ),
    );
  }
}