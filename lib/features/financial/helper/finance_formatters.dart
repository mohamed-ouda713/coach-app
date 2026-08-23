// lib/features/financial/helper/finance_formatters.dart

import 'package:glow_up/core/constants/app_strings.dart';
import 'package:intl/intl.dart';

abstract class FinanceFormatters {
  FinanceFormatters._();

  static final _numberFormat = NumberFormat('#,##0', 'en');
  static final _dayMonthFormat = DateFormat('d MMMM', 'ar');
  static final _monthYearFormat = DateFormat('MMMM yyyy', 'ar');

  /// "3,200"
  static String number(double value) => _numberFormat.format(value);

  /// "3,200 ريال"
  static String currency(double value) =>
      '${_numberFormat.format(value)} ${AppStrings.financeCurrency}';

  /// "1 يونيو"
  static String dayMonth(DateTime date) => _dayMonthFormat.format(date);

  /// "يونيو 2025"
  static String monthYear(DateTime date) => _monthYearFormat.format(date);
}