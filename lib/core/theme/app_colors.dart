import 'package:flutter/material.dart';

class AppColors {
  //make user cannot instantiate this class
  AppColors._();

  static const Color primary = Color(0xFF0EA5E9);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryDarker = Color(0xFF0369A1);
  static const Color accent = Color(0xFFF97316);

  static const Color categoryBlueStart = Color(0xFF0EA5E9);
  static const Color categoryBlueEnd = Color(0xFF0284C7);
  static const Color categoryPurpleStart = Color(0xFF8B5CF6);
  static const Color categoryPurpleEnd = Color(0xFF6D28D9);
  static const Color categoryTealStart = Color(0xFF06B6D4);
  static const Color categoryTealEnd = Color(0xFF0284C7);
  static const Color categoryAmberStart = Color(0xFFF59E0B);
  static const Color categoryAmberEnd = Color(0xFFD97706);

  static const List<Color> authGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF0369A1),
    Color(0xFF1A1A2E),
  ];

  static const Color financeIncome = Color(0xFF15803D);
  static const Color financeExpense = Color(0xFFB91C1C);
  static const Color financeNet = Color(0xFF0369A1);
  static const Color white = Color(0xFFFFFFFF);

  static const Color photoViewerBackground = Color(0xFF000000);
}

class AppColorsLight {
  AppColorsLight._();

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  static const Color bgScreen = Color(0xFFF1F5F9);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgSubtle = Color(0xFFF8FAFC);

  static const Color border = Color(0xFFE2E8F0);
  static const Color primarySoftBg = Color(0xFFE0F2FE);

  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF4F46E5);
  static const Color infoBg = Color(0xFFF0F4FF);
}
