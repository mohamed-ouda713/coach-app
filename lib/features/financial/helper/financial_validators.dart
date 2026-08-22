// lib/features/financial/helper/financial_validators.dart

import 'package:glow_up/core/constants/app_strings.dart';

abstract class FinancialValidators {
  FinancialValidators._();

  static String? expenseDescription(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.financeExpenseDescriptionRequired;
    return null;
  }

  static String? amount(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.feeRequired;
    final amount = double.tryParse(trimmed);
    if (amount == null || amount <= 0) return AppStrings.feeInvalid;
    return null;
  }

  static String? partnerName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.financePartnerNameRequired;
    return null;
  }

  /// [othersTotal] = مجموع نسب باقي الشركاء (بدون الشريك الحالي لو
  /// بحالة تعديل). لازم يوصل من الطرف المستدعي (partner_form_dialog).
  static String? sharePercentage(
    String? value, {
    required double othersTotal,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.financeSharePercentageRequired;
    final share = double.tryParse(trimmed);
    if (share == null || share < 0 || share > 100) {
      return AppStrings.financeSharePercentageInvalid;
    }
    if (othersTotal + share > 100) {
      return AppStrings.financeSharePercentageSumExceeded;
    }
    return null;
  }
}