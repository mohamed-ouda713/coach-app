/// نصوص الواجهة — مستخرجة من الشاشات F0 → F12 في ملفي التصميم.
/// اتشالت منها: تعليقات التصميم بالإنجليزي (زي "Hero app bar"، "Section")،
/// وقيم mock (الساعة 9:41، أرقام تجريبية زي 72 كغ)، لأنها مش نصوص ثابتة.
///
/// كل حاجة هنا static const عشان تتستخدم مباشرة، وبانت داخل كلاسات فرعية
/// حسب الشاشة، حتى لو فاضية دلوقتي (placeholders) عشان الأساس يبقى موجود.
class AppStrings {
  AppStrings._();

  // ── مشترك بين كل الشاشات ──────────────────────────────────
  static const String appName = 'كوتش برو';
  static const String tagline = 'إدارة عملائك باحترافية';

  static const String navClients = 'العملاء';
  static const String navMeasurements = 'القياسات';
  static const String navNotifications = 'الإشعارات';
  static const String navFinances = 'المالية';

  static const String actionSave = 'حفظ';
  static const String actionEdit = 'تعديل';
  static const String actionAdd = 'إضافة';
  static const String actionBack = 'رجوع';
  static const String dividerOr = 'أو';

  // Goals (تظهر في أكتر من شاشة: F0, F7, F9)
  static const String goalWeightLoss = 'خسارة وزن';
  static const String goalMuscleGain = 'زيادة كتلة';
  static const String goalGeneralFitness = 'لياقة عامة';
  static const String goalRecovery = 'تعافي';

  // Programs
  static const String programGym = 'جيم';
  static const String programHome = 'منزل';

  // Subscription status chips
  static const String statusActive = 'نشط';
  static const String statusExpiringSoon = 'ينتهي قريباً';
  static const String statusExpired = 'منتهي';
}

/// F1 — قائمة العملاء
class ClientsListStrings {
  ClientsListStrings._();

  static const String greeting = 'مرحباً';
  static const String searchHint = 'ابحث عن عميل...';
  static const String filterAll = 'الكل';
  static const String statTotal = 'إجمالي';
  static const String statActive = 'نشط';
  static const String statExpiring = 'ينتهي';
}

/// F2 — ملف العميل
class ClientProfileStrings {
  ClientProfileStrings._();

  static const String screenTitle = 'ملف العميل';
  static const String age = 'العمر';
  static const String weight = 'الوزن';
  static const String height = 'الطول';
  static const String unitKg = 'كغ';
  static const String unitCm = 'سم';
  static const String subscriptionDetails = 'تفاصيل الاشتراك';
  static const String startDate = 'تاريخ البدء';
  static const String endDate = 'تاريخ الانتهاء';
  static const String subscriptionAmount = 'مبلغ الاشتراك';
  static const String addMeasurementCta = 'إضافة قياس';
}

/// F3 — القياسات والتقدم
class MeasurementsStrings {
  MeasurementsStrings._();

  static const String overallProgress3Months = 'التقدم الإجمالي — 3 أشهر';
  static const String weightLabel = 'الوزن (كغ)';
  static const String waistLabel = 'الخصر (سم)';
  static const String bellyLabel = 'البطن (سم)';
  static const String monthlyLog = 'السجل الشهري';
  static const String photoBefore = 'صورة قبل';
  static const String photoAfter = 'صورة بعد';
}

/// F4 — الإشعارات
class NotificationsStrings {
  NotificationsStrings._();

  static const String markAllRead = 'قراءة الكل';
  // أمثلة نصوص إشعارات فعلية (تبقى Templates بتتبني ديناميك من الباك إند)
  static const String subscriptionEndingTemplate = 'اشتراك {name} ينتهي خلال {days} أيام';
  static const String missingMeasurementTemplate = '{name} لم تسجل قياساتها هذا الشهر';
  static const String needsNewProgramTemplate = '{name} تحتاج برنامجاً جديداً';
  static const String greatProgressTemplate = '{name}: تقدم ممتاز هذا الشهر';
  static const String timeAgoHour = 'منذ ساعة';
  static const String timeAgoDay = 'منذ يوم';
  static const String timeAgoDays3 = 'منذ 3 أيام';
  static const String timeAgoWeek = 'منذ أسبوع';
}

/// F5 — المالية
class FinancesStrings {
  FinancesStrings._();

  static const String income = 'الدخل';
  static const String expenses = 'المصروفات';
  static const String netProfit = 'صافي الربح';
  static const String currency = 'ريال';
  static const String profitSplit = 'قسمة الربح';
  static const String withdraw = 'سحب';
  static const String balance = 'الرصيد:';
  static const String addNewPartner = 'إضافة طرف جديد';
}

/// F6 — تسجيل الدخول
class LoginStrings {
  LoginStrings._();

  static const String welcomeBack = 'مرحباً بعودتك';
  static const String signInToContinue = 'سجّلي دخولك للمتابعة';
  static const String emailLabel = 'البريد الإلكتروني';
  static const String passwordLabel = 'كلمة المرور';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String loginCta = 'تسجيل الدخول';
  static const String noAccount = 'ليس لديك حساب؟';
  static const String contactUs = 'تواصلي معنا';
}

/// F7 — إضافة عميلة جديدة
class AddClientStrings {
  AddClientStrings._();

  static const String screenTitle = 'عميلة جديدة';
  static const String fullNameLabel = 'الاسم الكامل';
  static const String fullNameHint = 'اسم العميلة...';
  static const String physicalDataSection = 'البيانات الجسمانية';
  static const String goalSection = 'الهدف';
  static const String programSection = 'البرنامج';
  static const String subscriptionSection = 'الاشتراك';
  static const String amountLabel = 'المبلغ (ريال)';
  static const String noteLabel = 'ملاحظة';
  static const String noteHintExample = 'مثال: دفعتين...';
  static const String dateHint = 'dd / mm / yyyy';
}

/// F8 — قياس جديد
class AddMeasurementStrings {
  AddMeasurementStrings._();

  static const String screenTitle = 'قياس جديد';
  static const String addMonthlyMeasurement = 'إضافة قياس شهري';
  static const String monthLabel = 'الشهر';
  static const String photosLabel = 'الصور';
  static const String saveMeasurementCta = 'حفظ القياس';
}

/// F9 — تعديل ملف العميل
class EditClientStrings {
  EditClientStrings._();

  static const String screenTitle = 'تعديل ملف العميل';
  static const String saveChangesCta = 'حفظ التعديلات';
  static const String deleteClient = 'حذف العميلة';
}

/// F10 — إنشاء حساب جديد
class SignUpStrings {
  SignUpStrings._();

  static const String welcomeLetsStart = 'أهلاً بك، لنبدأ معاً';
  static const String screenTitle = 'إنشاء حساب جديد';
  static const String enterDataToStart = 'أدخلي بياناتك للبدء';
  static const String createAccountCta = 'إنشاء الحساب';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل؟';
}

/// F11 / F12 — نسيت كلمة المرور
class ForgotPasswordStrings {
  ForgotPasswordStrings._();

  static const String recoverPassword = 'استعادة كلمة المرور';
  static const String forgotPasswordTitle = 'نسيت كلمة المرور؟';
  static const String enterEmailInstructions = 'أدخلي بريدك الإلكتروني وسنرسل لك رابط الاستعادة';
  static const String sendResetLinkCta = 'إرسال رابط الاستعادة';
  static const String backToLogin = 'العودة لتسجيل الدخول';

  static const String linkSentTitle = 'تم الإرسال بنجاح';
  static const String emailSentHeading = 'تم الإرسال!';
  static const String checkEmailInstructions = 'تحقّقي من بريدك الإلكتروني واتّبعي الرابط لإعادة التعيين';
  static const String openEmailCta = 'فتح البريد الإلكتروني';
  static const String didNotReceiveEmail = 'لم تصلك الرسالة؟';
  static const String resend = 'إعادة الإرسال';
}
