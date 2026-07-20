/// قيم الـ Border Radius — مستخرجة من كل الشاشات (F0 → F12) في ملفي التصميم.
class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 7;
  static const double smMd = 8;
  static const double md = 10;
  static const double mdLg = 11;
  static const double card = 12; // أزرار / حقول صغيرة
  static const double cardMd = 13;
  static const double cardLg = 14; // الأكثر استخدامًا للكروت والأزرار الكبيرة
  static const double lg = 16;
  static const double clientCard = 18; // بطاقة العميل
  static const double xl = 19;
  static const double badge = 20; // pill/badges مستديرة (الأعلى تكرارًا بكل قيم الـ radius)
  static const double xxl = 21;
  static const double sheet = 28; // شيت الفورم فوق خلفية الـ auth
  static const double sheetAlt = 29;
  static const double avatarSm = 23; // نص/دائرة أفاتار صغير (46px width /2)
  static const double avatarMd = 33; // أفاتار متوسط (66px /2)
  static const double avatarLg = 34;
  static const double iconCircleLg = 38;
  static const double iconCircleXl = 42; // دائرة أيقونة اللوجو
  static const double phoneFrame = 46; // زوايا إطار الموبايل بالكامل
  static const double pill = 999; // استخدم ده لأي عنصر دائري بالكامل (chips الحالة)
}