import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 10;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 18;
  static const double xxl = 20;
  static const double pill = 999; // شرائح/chips دائرية بالكامل

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
}

/// ظل الكارت الموحّد المستخدم في كل بطاقات الديزاين
/// (box-shadow: 0 2px 12px rgba(0,0,0,.05) / .06 / .09)
class AppShadows {
  AppShadows._();

  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> cardStrong = [
    BoxShadow(
      color: Colors.black.withOpacity(0.09),
      blurRadius: 28,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> phoneFrame = [
    BoxShadow(
      color: Colors.black.withOpacity(0.42),
      blurRadius: 72,
      offset: const Offset(0, 28),
    ),
  ];
}
