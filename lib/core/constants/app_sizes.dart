/// أحجام المكونات — ارتفاعات، أيقونات، أفاتارات، إطار التصميم المرجعي.
/// مستخرجة من كل الشاشات (F0 → F12) في ملفي التصميم.
class AppSizes {
  AppSizes._();

  // إطار الموبايل (مرجعي — Design frame، مش بالضرورة لازم يتنسخ حرفيًا في التطبيق)
  static const double phoneFrameWidth = 390;
  static const double phoneFrameHeight = 844;
  static const double statusBarHeight = 52;

  // ارتفاعات مكونات متكررة
  static const double inputHeightSm = 48; // حقول إدخال بعرض/سياق تاني (8 مرات)
  static const double inputHeightMd = 50; // حقول إدخال + بعض الأزرار (19 مرة — الأكثر استخدامًا فعليًا)
  static const double inputHeight = 52; // حقل/زر افتراضي (18 مرة)
  static const double buttonHeightXs = 36; // أزرار صغيرة (3 مرات) + حاويات أيقونة مربعة 36×36 (5 مرات)
  static const double toggleHeight = 32; // segmented control / toggle (20 مرة — الأعلى تكرارًا بكل قيم الـ height)
  static const double buttonHeightSm = 46;
  static const double buttonHeightMd = 52;
  static const double buttonHeightLg = 54;
  static const double bottomNavHeight = 78;

  // أيقونات
  static const double iconXxs = 12; // نادر (مرتين)
  static const double iconXs = 14;
  static const double iconSm = 15;
  static const double iconMd = 16;
  static const double iconLg = 17;
  static const double iconXl = 18;
  static const double icon = 20; // الأكثر استخدامًا لكل الأيقونات (28 مرة)
  static const double iconXxl0 = 25; // شائع كمان (12 مرة)
  static const double iconXxl = 32;
  static const double iconDisplay = 34;

  static const double photoThumb = 96;

  // أفاتارات
  static const double avatarSm = 46;
  static const double avatarMd = 66;
  static const double avatarLogo = 84;

  static const double splashLogo = 180;
}