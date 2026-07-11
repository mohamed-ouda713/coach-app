/// أحجام ومسافات — Border radius / Spacing / Icon sizes / Component heights
/// مستخرجة من كل الشاشات (F0 → F12) في ملفي التصميم.
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
  static const double badge = 20; // pill/badges مستديرة
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

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 6;
  static const double smMd = 8;
  static const double md = 10;
  static const double mdLg = 12;
  static const double lg = 14;
  static const double lgAlt = 16;
  static const double xl = 20;
  static const double xxl = 22;
  static const double xxxl = 24;
  static const double screenPadding = 26; // بادينج الشاشات الجانبي في auth
}

class AppSizes {
  AppSizes._();

  // إطار الموبايل (مرجعي — Design frame، مش بالضرورة لازم يتنسخ حرفيًا في التطبيق)
  static const double phoneFrameWidth = 390;
  static const double phoneFrameHeight = 844;
  static const double statusBarHeight = 52;

  // ارتفاعات مكونات متكررة
  static const double inputHeight = 52;
  static const double buttonHeightLg = 54;
  static const double buttonHeightMd = 52;
  static const double buttonHeightSm = 46;

  // أيقونات
  static const double iconXs = 14;
  static const double iconSm = 15;
  static const double iconMd = 16;
  static const double iconLg = 17;
  static const double iconXl = 18;
  static const double iconXxl = 32;
  static const double iconDisplay = 34;

  // أفاتارات
  static const double avatarSm = 46;
  static const double avatarMd = 66;
  static const double avatarLogo = 84;
}

class AppBorders {
  AppBorders._();

  static const double thin = 1;
  static const double regular = 1.5; // حدود الحقول (input focus/default)
}
