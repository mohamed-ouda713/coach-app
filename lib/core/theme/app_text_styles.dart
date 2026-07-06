import 'package:flutter/material.dart';


/// سلّم الطباعة (Typography scale) بتاع تطبيق "كوتش برو"
/// الخط المستخدم في الديزاين: IBM Plex Sans Arabic
/// (متاح جاهز على Google Fonts، فمستخدمينه عن طريق حزمة google_fonts
/// بدل ما نحمّل ملفات الخط يدويًا — لو حبيتوا تبندلوه offline
/// بعدين، بس هتضيفوا الملفات في assets/fonts وتغيّروا family هنا).
///
/// اللون مش متضمن جوه الـ TextStyle الأساسي عشان يفضل الملف صالح
/// للفاتح والداكن مع بعض؛ اللون بيتحدد وقت الاستخدام حسب الثيم:
///   Text('نص', style: AppTextStyles.bodyM.copyWith(color: AppColorsLight.textPrimary))
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.ibmPlexSansArabic(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ── عناوين رئيسية ───────────────────────────────────────────
  static final TextStyle displayXL = _base(size: 26, weight: FontWeight.w700); // شاشات صورة البروفايل
  static final TextStyle display = _base(size: 24, weight: FontWeight.w700); // "تم الإرسال!"
  static final TextStyle h1 = _base(size: 22, weight: FontWeight.w700); // عنوان رئيسي (Bold 22)
  static final TextStyle h2 = _base(size: 20, weight: FontWeight.w700); // عنوان قسم كبير
  static final TextStyle h3 = _base(size: 19, weight: FontWeight.w700);
  static final TextStyle h4 = _base(size: 18, weight: FontWeight.w700);
  static final TextStyle h5 = _base(size: 17, weight: FontWeight.w600); // عنوان ثانوي (SemiBold 17)

  // ── عناوين قسم صغيرة (labels فوق كل مجموعة) ─────────────────
  static final TextStyle sectionLabel = _base(
    size: 11,
    weight: FontWeight.w700,
    letterSpacing: 1.2,
  ); // "الألوان" / "الطباعة" ... إلخ

  // ── نص العنوان داخل الأزرار ──────────────────────────────────
  static final TextStyle buttonL = _base(size: 16, weight: FontWeight.w700); // زر رئيسي كبير
  static final TextStyle buttonM = _base(size: 15, weight: FontWeight.w600);
  static final TextStyle buttonS = _base(size: 14, weight: FontWeight.w600); // زر رئيسي/ثانوي في اللوحة

  // ── أرقام إحصائية (شرائح الإحصاء / بطاقات القياسات) ─────────
  static final TextStyle statNumber = _base(size: 20, weight: FontWeight.w700);
  static final TextStyle statNumberS = _base(size: 18, weight: FontWeight.w700);

  // ── نص أساسي (Body) ─────────────────────────────────────────
  static final TextStyle bodyL = _base(size: 15, weight: FontWeight.w500); // نص أساسي (Medium 15)
  static final TextStyle bodyM = _base(size: 14, weight: FontWeight.w500);
  static final TextStyle bodyRegular = _base(size: 14, weight: FontWeight.w400); // نص إدخال placeholder
  static final TextStyle bodyS = _base(size: 13, weight: FontWeight.w500);
  static final TextStyle bodyRegularS = _base(size: 13, weight: FontWeight.w400); // نص ثانوي (Regular 13)

  // ── شرائح/تصنيفات (chips/badges) ─────────────────────────────
  static final TextStyle chip = _base(size: 12, weight: FontWeight.w500);
  static final TextStyle chipBold = _base(size: 11, weight: FontWeight.w600);

  // ── تسميات الحقول (form field labels) ───────────────────────
  static final TextStyle fieldLabel = _base(size: 12, weight: FontWeight.w500);

  // ── نصوص مساعدة/صغيرة (captions) ────────────────────────────
  static final TextStyle caption = _base(size: 11, weight: FontWeight.w400);
  static final TextStyle captionMedium = _base(size: 11, weight: FontWeight.w500);
  static final TextStyle captionLight = _base(size: 11, weight: FontWeight.w300); // نص مساعد (Light 11)

  // ── أصغر نص (bottom nav / أرقام شرائح الإحصاء الصغيرة) ──────
  static final TextStyle tiny = _base(size: 10, weight: FontWeight.w400);
  static final TextStyle tinyBold = _base(size: 10, weight: FontWeight.w600);

  // ── نص الساعة في status bar ──────────────────────────────────
  static final TextStyle statusBarTime = _base(size: 15, weight: FontWeight.w600);
}
