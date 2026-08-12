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

  static const String homeWelcomeGreeting = 'مرحباً';
  static const String homeAddTooltip = 'إضافة';
  static const String homeNotificationsTooltip = 'الإشعارات';
  static const String logoutCta = 'تسجيل الخروج';
  static const String comingSoon = 'قريباً';

  static const String profileTitle = 'الملف الشخصي';
  static const String profileFullNameLabel = 'الاسم الكامل';
  static const String profileEmailLabel = 'البريد الإلكتروني';
  static const String profileAppearanceLabel = 'المظهر';
  static const String themeLight = 'فاتح';
  static const String themeDark = 'غامق';
  static const String logoutConfirmMessage = 'هل أنت متأكد إنك بدك تسجل خروج؟';

  // 🆕 نصوص مضافة للـ Dialogs والـ SnackBars والـ Views العامة
  static const String dialogConfirmOk = 'حسناً';
  static const String dialogCancel = 'إلغاء';
  static const String errorViewRetry = 'إعادة المحاولة';
  static const String defaultErrorTitle = 'تنبيه';
  static const String defaultErrorMessage =
      'حدث خطأ ما، يرجى المحاولة مرة أخرى.';
      static const String tempEmailNotAllowed =
      'غير مسموح باستخدام بريد إلكتروني مؤقت أو وهمي'; // 👈 المتغير الجديد

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
  static const String measurementsOverallProgress3Months =
      'التقدم الإجمالي — 3 أشهر';
  static const String measurementsWeightLabel = 'الوزن (كغ)';
  static const String measurementsWaistLabel = 'الخصر (سم)';
  static const String measurementsBellyLabel = 'البطن (سم)';
  static const String measurementsMonthlyLog = 'السجل الشهري';
  static const String measurementsPhotoBefore = 'صورة قبل';
  static const String measurementsPhotoAfter = 'صورة بعد';
  static const String measurementsEmptyHistory = 'لا يوجد قياسات مسجلة بعد';
  static const String measurementsNotEnoughForProgress = 'لا توجد بيانات كافية لعرض التقدم';

  // ── F4 — الإشعارات ─────────────────────────────────────────
  static const String notificationsMarkAllRead = 'قراءة الكل';
  // أمثلة نصوص إشعارات فعلية (تبقى Templates بتتبني ديناميك من الباك إند)
  static const String notificationSubscriptionEndingTemplate =
      'اشتراك {name} ينتهي خلال {days} أيام';
  static const String notificationMissingMeasurementTemplate =
      '{name} لم تسجل قياساتها هذا الشهر';
  static const String notificationNeedsNewProgramTemplate =
      '{name} تحتاج برنامجاً جديداً';
  static const String notificationGreatProgressTemplate =
      '{name}: تقدم ممتاز هذا الشهر';
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
  static const String signUpSuccessMessage = 'تم إنشاء الحساب بنجاح';
  static const String signUpConfirmEmailMessage =
      'تم إنشاء الحساب! تحقّقي من بريدك الإلكتروني لتأكيد الحساب قبل تسجيل الدخول';
  static const String loginSuccessMessage = 'تم تسجيل الدخول بنجاح';
  //  نصوص التحقق من الصحة (Validation)
  static const String nameRequired = 'يرجى إدخال الاسم الكامل';
  static const String emailRequired = 'يرجى إدخال البريد الإلكتروني';
  static const String invalidEmail = 'يرجى إدخال بريد إلكتروني صحيح';
  static const String passwordRequired = 'يرجى إدخال كلمة المرور';
  static const String passwordTooShort = 'كلمة المرور يجب أن لا تقل عن 8 أحرف';
  static const String passwordMissingUppercase =
      'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل (A-Z)';
  static const String passwordMissingLowercase =
      'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل (a-z)';
  static const String passwordMissingDigit =
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (0-9)';
  static const String passwordHint =
      '8 أحرف على الأقل، تحتوي على حرف كبير وحرف صغير ورقم';

  // ── F11 / F12 — نسيت كلمة المرور ───────────────────────────
  static const String forgotPasswordRecoverPassword = 'استعادة كلمة المرور';
  static const String forgotPasswordTitle = 'نسيت كلمة المرور؟';
  static const String forgotPasswordEnterEmailInstructions =
      'أدخلي بريدك الإلكتروني وسنرسل لك رابط الاستعادة';
  static const String forgotPasswordSendResetLinkCta = 'إرسال رابط الاستعادة';
  static const String forgotPasswordBackToLogin = 'العودة لتسجيل الدخول';

  static const String forgotPasswordLinkSentTitle = 'تم الإرسال بنجاح';
  static const String forgotPasswordEmailSentHeading = 'تم الإرسال!';
  static const String forgotPasswordCheckEmailInstructions =
      'تحقّقي من بريدك الإلكتروني واتّبعي الرابط لإعادة التعيين';
  static const String forgotPasswordOpenEmailCta = 'فتح البريد الإلكتروني';
  static const String forgotPasswordDidNotReceiveEmail = 'لم تصلك الرسالة؟';
  static const String forgotPasswordResend = 'إعادة الإرسال';

  // ── تعيين كلمة مرور جديدة (تكملة F11 / F12) ────────────────
  static const String resetPasswordTitle = 'كلمة مرور جديدة';
  static const String resetPasswordInstructions =
      'أدخلي كلمة المرور الجديدة الخاصة بحسابك';
  static const String resetPasswordNewPasswordLabel = 'كلمة المرور الجديدة';
  static const String resetPasswordConfirmPasswordLabel = 'تأكيد كلمة المرور';
  static const String resetPasswordMismatch = 'كلمتا المرور غير متطابقتين';
  static const String resetPasswordSubmitCta = 'حفظ كلمة المرور';

  // ── Subscribers — فورم إضافة/تعديل عميلة (F7 / F9) ─────────
  // نصوص التحقق (Validation) الخاصة بحقول الفورم
  static const String subscriberNameRequired = 'يرجى إدخال اسم العميلة';
  static const String subscriberNameTooShort =
      'الاسم يجب أن يحتوي على 3 حروف على الأقل';
  static const String subscriberNameInvalidChars =
      'الاسم يحتوي على رموز غير مسموح بها';
  static const String fieldRequiredShort = 'مطلوب';
  static const String ageInvalid = 'عمر غير منطقي';
  static const String heightInvalid = 'طول غير منطقي';
  static const String weightInvalid = 'وزن غير منطقي';
  static const String feeRequired = 'يرجى إدخال المبلغ';
  static const String feeInvalid = 'مبلغ غير صالح';
  static const String noteTooLong =
      'الملاحظة طويلة جداً (يجب ألا تتجاوز 60 حرف)';
  static const String ageUnitYear = 'سنة';

  static const String subscriptionDatesRequired =
      'يرجى اختيار تاريخ البدء والانتهاء';
  static const String subscriptionDateOrderInvalid =
      'تاريخ الانتهاء يجب أن يكون بعد تاريخ البدء';

  // رسائل نجاح/تأكيد
  static const String addSubscriberSuccessMessage = 'تمت إضافة العميلة بنجاح';
  static const String editSubscriberSuccessMessage = 'تم حفظ التعديلات بنجاح';
  static const String deleteSubscriberConfirmMessage =
      'هل أنتِ متأكدة من حذف هذه العميلة؟ لا يمكن التراجع عن هذا الإجراء.';

  // قائمة العملاء وشاشة التعديل
  static const String noMatchingClients = 'لا يوجد عملاء مطابقين';
  static const String loadSubscriberError = 'تعذر تحميل بيانات العميلة';
}