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

  // 🆕 نصوص مضافة للـ Dialogs والـ SnackBars والـ Views العامة
  static const String dialogConfirmOk = 'حسناً';
  static const String dialogCancel = 'إلغاء';
  static const String errorViewRetry = 'إعادة المحاولة';
  static const String defaultErrorTitle = 'تنبيه';
  static const String defaultErrorMessage = 'حدث خطأ ما، يرجى المحاولة مرة أخرى.';

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

  // ── F1 — قائمة العملاء ─────────────────────────────────────
  static const String clientsGreeting = 'مرحباً';
  static const String clientsSearchHint = 'ابحث عن عميل...';
  static const String clientsFilterAll = 'الكل';
  static const String clientsStatTotal = 'إجمالي';
  static const String clientsStatActive = 'نشط';
  static const String clientsStatExpiring = 'ينتهي';

  // ── F2 — ملف العميل ────────────────────────────────────────
  static const String clientProfileScreenTitle = 'ملف العميل';
  static const String clientAge = 'العمر';
  static const String clientWeight = 'الوزن';
  static const String clientHeight = 'الطول';
  static const String unitKg = 'كغ';
  static const String unitCm = 'سم';
  static const String subscriptionDetails = 'تفاصيل الاشتراك';
  static const String subscriptionStartDate = 'تاريخ البدء';
  static const String subscriptionEndDate = 'تاريخ الانتهاء';
  static const String subscriptionAmount = 'مبلغ الاشتراك';
  static const String addMeasurementCta = 'إضافة قياس';

  // ── F3 — القياسات والتقدم ──────────────────────────────────
  static const String measurementsOverallProgress3Months = 'التقدم الإجمالي — 3 أشهر';
  static const String measurementsWeightLabel = 'الوزن (كغ)';
  static const String measurementsWaistLabel = 'الخصر (سم)';
  static const String measurementsBellyLabel = 'البطن (سم)';
  static const String measurementsMonthlyLog = 'السجل الشهري';
  static const String measurementsPhotoBefore = 'صورة قبل';
  static const String measurementsPhotoAfter = 'صورة بعد';

  // ── F4 — الإشعارات ─────────────────────────────────────────
  static const String notificationsMarkAllRead = 'قراءة الكل';
    // أمثلة نصوص إشعارات فعلية (تبقى Templates بتتبني ديناميك من الباك إند)
  static const String notificationSubscriptionEndingTemplate = 'اشتراك {name} ينتهي خلال {days} أيام';
  static const String notificationMissingMeasurementTemplate = '{name} لم تسجل قياساتها هذا الشهر';
  static const String notificationNeedsNewProgramTemplate = '{name} تحتاج برنامجاً جديداً';
  static const String notificationGreatProgressTemplate = '{name}: تقدم ممتاز هذا الشهر';
  static const String timeAgoHour = 'منذ ساعة';
  static const String timeAgoDay = 'منذ يوم';
  static const String timeAgoDays3 = 'منذ 3 أيام';
  static const String timeAgoWeek = 'منذ أسبوع';

  // ── F5 — المالية ───────────────────────────────────────────
  static const String financeIncome = 'الدخل';
  static const String financeExpenses = 'المصروفات';
  static const String financeNetProfit = 'صافي الربح';
  static const String financeCurrency = 'ريال';
  static const String financeProfitSplit = 'قسمة الربح';
  static const String financeWithdraw = 'سحب';
  static const String financeBalance = 'الرصيد:';
  static const String financeAddNewPartner = 'إضافة طرف جديد';

  // ── F6 — تسجيل الدخول ──────────────────────────────────────
  static const String loginWelcomeBack = 'مرحباً بعودتك';
  static const String loginSignInToContinue = 'سجّلي دخولك للمتابعة';
  static const String loginEmailLabel = 'البريد الإلكتروني';
  static const String loginPasswordLabel = 'كلمة المرور';
  static const String loginForgotPassword = 'نسيت كلمة المرور؟';
  static const String loginCta = 'تسجيل الدخول';
  static const String loginNoAccount = 'ليس لديك حساب؟';
  static const String loginContactUs = 'تواصلي معنا';

  // ── F7 — إضافة عميلة جديدة ─────────────────────────────────
  static const String addClientScreenTitle = 'عميلة جديدة';
  static const String addClientFullNameLabel = 'الاسم الكامل';
  static const String addClientFullNameHint = 'اسم العميلة...';
  static const String addClientPhysicalDataSection = 'البيانات الجسمانية';
  static const String addClientGoalSection = 'الهدف';
  static const String addClientProgramSection = 'البرنامج';
  static const String addClientSubscriptionSection = 'الاشتراك';
  static const String addClientAmountLabel = 'المبلغ (ريال)';
  static const String addClientNoteLabel = 'ملاحظة';
  static const String addClientNoteHintExample = 'مثال: دفعتين...';
  static const String addClientDateHint = 'dd / mm / yyyy';

  // ── F8 — قياس جديد ─────────────────────────────────────────
  static const String addMeasurementScreenTitle = 'قياس جديد';
  static const String addMonthlyMeasurement = 'إضافة قياس شهري';
  static const String addMeasurementMonthLabel = 'الشهر';
  static const String addMeasurementPhotosLabel = 'الصور';
  static const String saveMeasurementCta = 'حفظ القياس';

  // ── F9 — تعديل ملف العميل ──────────────────────────────────
  static const String editClientScreenTitle = 'تعديل ملف العميل';
  static const String editClientSaveChangesCta = 'حفظ التعديلات';
  static const String editClientDeleteClient = 'حذف العميلة';

  // ── F10 — إنشاء حساب جديد ──────────────────────────────────
  static const String signUpWelcomeLetsStart = 'أهلاً بك، لنبدأ معاً';
  static const String signUpScreenTitle = 'إنشاء حساب جديد';
  static const String signUpEnterDataToStart = 'أدخلي بياناتك للبدء';
  static const String createAccountCta = 'إنشاء الحساب';
  static const String signUpAlreadyHaveAccount = 'لديك حساب بالفعل؟';

  // ── F11 / F12 — نسيت كلمة المرور ───────────────────────────
  static const String forgotPasswordRecoverPassword = 'استعادة كلمة المرور';
  static const String forgotPasswordTitle = 'نسيت كلمة المرور؟';
  static const String forgotPasswordEnterEmailInstructions = 'أدخلي بريدك الإلكتروني وسنرسل لك رابط الاستعادة';
  static const String forgotPasswordSendResetLinkCta = 'إرسال رابط الاستعادة';
  static const String forgotPasswordBackToLogin = 'العودة لتسجيل الدخول';

  static const String forgotPasswordLinkSentTitle = 'تم الإرسال بنجاح';
  static const String forgotPasswordEmailSentHeading = 'تم الإرسال!';
  static const String forgotPasswordCheckEmailInstructions = 'تحقّقي من بريدك الإلكتروني واتّبعي الرابط لإعادة التعيين';
  static const String forgotPasswordOpenEmailCta = 'فتح البريد الإلكتروني';
  static const String forgotPasswordDidNotReceiveEmail = 'لم تصلك الرسالة؟';
  static const String forgotPasswordResend = 'إعادة الإرسال';
}