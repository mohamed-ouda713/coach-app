import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── اللون الأساسي (ثابت في الفاتح والداكن) ──────────────────
  static const Color primary = Color(0xFF0EA5E9); // سماوي
  static const Color primaryDark = Color(0xFF0284C7); // سماوي غامق (hover/gradient)
  static const Color primaryLight = Color(0xFF38BDF8); // سماوي فاتح (مستخدم في الديزاين الداكن)
  static const Color accent = Color(0xFFF97316); // برتقالي مميز

  // ── ألوان إضافية مستخدمة في شرائح/تصنيفات ────────────────────
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleDark = Color(0xFF6D28D9);
  static const Color teal = Color(0xFF06B6D4);
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);

  // ── خلفية الفريم الخاصة بشاشات الـ splash/gradient ──────────
  static const Color navySplash = Color(0xFF1A1A2E);
  static const Color navySplash2 = Color(0xFF1E1E2E);
}

/// ألوان الوضع الفاتح (Light Mode) — من Fitness_Coach_App_dc.html
class AppColorsLight {
  AppColorsLight._();

  // النصوص
  static const Color textPrimary = Color(0xFF0F172A); // نص أساسي
  static const Color textSecondary = Color(0xFF64748B); // نص ثانوي
  static const Color textTertiary = Color(0xFF94A3B8); // نص مساعد
  static const Color textDisabled = Color(0xFFCBD5E1); // نص/أيقونة غير مفعّلة

  // الخلفيات والحدود
  static const Color bgScreen = Color(0xFFF1F5F9); // خلفية الشاشة
  static const Color bgCard = Color(0xFFFFFFFF); // خلفية الكارت
  static const Color bgSubtle = Color(0xFFF8FAFC); // خلفية فرعية (تفتيح خفيف)
  static const Color border = Color(0xFFE2E8F0); // حدود الحقول والفواصل

  // شرائح اللون الأساسي (خلفية فاتحة تُستخدم مع primary)
  static const Color primarySoftBg = Color(0xFFE0F2FE);

  // حالات (Status)
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEF2F2);
  static const Color dangerStrong = Color(0xFFB91C1C);
  static const Color info = Color(0xFF4F46E5);
  static const Color infoBg = Color(0xFFF0F4FF);
}

/// ألوان الوضع الداكن (Dark Mode) — من Fitness_Coach_App_Dark_dc.html
class AppColorsDark {
  AppColorsDark._();

  // النصوص
  static const Color textPrimary = Color(0xFFEEF2FF); // نص أساسي (شبه أبيض)
  static const Color textSecondary = Color(0xFF8892A4); // نص ثانوي
  static const Color textTertiary = Color(0xFF94A3B8); // نص مساعد
  static const Color textDisabled = Color(0xFF4E5A6B);

  // الخلفيات والحدود
  static const Color bgScreen = Color(0xFF0D0D14); // خلفية الشاشة
  static const Color bgCard = Color(0xFF181825); // خلفية الكارت
  static const Color bgSubtle = Color(0xFF252535); // خلفية فرعية/حقول إدخال
  static const Color border = Color(0xFF252535);

  // شرائح اللون الأساسي
  static const Color primarySoftBg = Color(0xFF0C2233);

  // حالات (Status)
  static const Color success = Color(0xFF4ADE80);
  static const Color successBg = Color(0xFF0A2317);
  static const Color warning = Color(0xFFFBBF24);
  static const Color warningBg = Color(0xFF211505);
  static const Color danger = Color(0xFFF87171);
  static const Color dangerBg = Color(0xFF220808);
  static const Color info = Color(0xFFA78BFA);
  static const Color infoBg = Color(0xFF170F2E);
}
