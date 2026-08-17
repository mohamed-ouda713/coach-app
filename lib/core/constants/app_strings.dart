import 'package:glow_up/core/localization/app_locale.dart';

class AppStrings {
  AppStrings._();

  static String _t(String ar, String en) => AppLocale.t(ar, en);

  // ── مشترك بين كل الشاشات ──────────────────────────────────
  static String get appName => _t('كوتش برو', 'Coach Pro');
  static String get tagline =>
      _t('إدارة عملائك باحترافية', 'Manage your clients professionally');

  static String get navClients => _t('العملاء', 'Clients');
  static String get navMeasurements => _t('القياسات', 'Measurements');
  static String get navNotifications => _t('الإشعارات', 'Notifications');
  static String get navFinances => _t('المالية', 'Finances');

  static String get actionSave => _t('حفظ', 'Save');
  static String get actionEdit => _t('تعديل', 'Edit');
  static String get actionAdd => _t('إضافة', 'Add');
  static String get actionBack => _t('رجوع', 'Back');
  static String get dividerOr => _t('أو', 'or');

  static String get homeWelcomeGreeting => _t('مرحباً', 'Welcome');
  static String get homeAddTooltip => _t('إضافة', 'Add');
  static String get homeNotificationsTooltip =>
      _t('الإشعارات', 'Notifications');
  static String get logoutCta => _t('تسجيل الخروج', 'Log out');
  static String get comingSoon => _t('قريباً', 'Coming soon');
  static String get checkingSession =>
      _t('جاري التحقق من الجلسة...', 'Checking session...');

  static String get profileTitle => _t('الملف الشخصي', 'Profile');
  static String get profileFullNameLabel => _t('الاسم الكامل', 'Full name');
  static String get profileEmailLabel => _t('البريد الإلكتروني', 'Email');
  static String get profileAppearanceLabel => _t('المظهر', 'Appearance');
  static String get profileLanguageLabel => _t('اللغة', 'Language');
  static String get themeSystem => _t('حسب الجهاز', 'System');
  static String get themeLight => _t('فاتح', 'Light');
  static String get themeDark => _t('غامق', 'Dark');
  static String get logoutConfirmMessage => _t(
    'هل أنت متأكد إنك بدك تسجل خروج؟',
    'Are you sure you want to log out?',
  );

  // 🆕 نصوص مضافة للـ Dialogs والـ SnackBars والـ Views العامة
  static String get dialogConfirmOk => _t('حسناً', 'OK');
  static String get dialogCancel => _t('إلغاء', 'Cancel');
  static String get errorViewRetry => _t('إعادة المحاولة', 'Retry');
  static String get defaultErrorTitle => _t('تنبيه', 'Notice');
  static String get defaultErrorMessage => _t(
    'حدث خطأ ما، يرجى المحاولة مرة أخرى.',
    'Something went wrong, please try again.',
  );
  static String get tempEmailNotAllowed => _t(
    'غير مسموح باستخدام بريد إلكتروني مؤقت أو وهمي',
    'Temporary or disposable email addresses are not allowed',
  );

  // Goals (تظهر في أكتر من شاشة: F0, F7, F9)
  static String get goalWeightLoss => _t('خسارة وزن', 'Weight loss');
  static String get goalMuscleGain => _t('زيادة كتلة', 'Muscle gain');
  static String get goalGeneralFitness => _t('لياقة عامة', 'General fitness');
  static String get goalRecovery => _t('تعافي', 'Recovery');

  // Programs
  static String get programGym => _t('جيم', 'Gym');
  static String get programHome => _t('منزل', 'Home');

  // Subscription status chips
  static String get statusActive => _t('نشط', 'Active');
  static String get statusExpiringSoon => _t('ينتهي قريباً', 'Expiring soon');
  static String get statusExpired => _t('منتهي', 'Expired');

  // ── F1 — قائمة العملاء ─────────────────────────────────────
  static String get clientsGreeting => _t('مرحباً', 'Welcome');
  static String get clientsSearchHint =>
      _t('ابحث عن عميل...', 'Search for a client...');
  static String get clientsFilterAll => _t('الكل', 'All');
  static String get clientsStatTotal => _t('إجمالي', 'Total');
  static String get clientsStatActive => _t('نشط', 'Active');
  static String get clientsStatExpiring => _t('ينتهي', 'Expiring');

  // ── F2 — ملف العميل ────────────────────────────────────────
  static String get clientProfileScreenTitle =>
      _t('ملف العميل', 'Client profile');
  static String get clientAge => _t('العمر', 'Age');
  static String get clientWeight => _t('الوزن', 'Weight');
  static String get clientHeight => _t('الطول', 'Height');
  static String get unitKg => _t('كغ', 'kg');
  static String get unitCm => _t('سم', 'cm');
  static String get subscriptionDetails =>
      _t('تفاصيل الاشتراك', 'Subscription details');
  static String get subscriptionStartDate => _t('تاريخ البدء', 'Start date');
  static String get subscriptionEndDate => _t('تاريخ الانتهاء', 'End date');
  static String get subscriptionAmount =>
      _t('مبلغ الاشتراك', 'Subscription amount');
  static String get addMeasurementCta => _t('إضافة قياس', 'Add measurement');

  // ── F3 — القياسات والتقدم ──────────────────────────────────
  static String get measurementsOverallProgress3Months =>
      _t('التقدم الإجمالي — 3 أشهر', 'Overall progress — 3 months');
  static String get measurementsWeightLabel => _t('الوزن (كغ)', 'Weight (kg)');
  static String get measurementsWaistLabel => _t('الخصر (سم)', 'Waist (cm)');
  static String get measurementsBellyLabel => _t('البطن (سم)', 'Belly (cm)');
  static String get measurementsStatWeight =>
      _t('$unitKg وزن', 'Weight $unitKg');
  static String get measurementsStatWaist => _t('$unitCm خصر', 'Waist $unitCm');
  static String get measurementsStatBelly => _t('$unitCm بطن', 'Belly $unitCm');
  static String get measurementsMonthlyLog => _t('السجل الشهري', 'Monthly log');
  static String get measurementsPickClientHint => _t(
    'اختاري العميلة التي تودين مشاهدة أو تسجيل القياسات الخاصة فيها',
    'Choose the client whose measurements you want to view or record',
  );
  static String get measurementsPickClientLabel => _t('العميلة', 'Client');
  static String get measurementsPickClientRequired =>
      _t('يرجى اختيار العميلة', 'Please select a client');
  static String get measurementsDuplicateMonth => _t(
    'يوجد قياس مسجّل لهذه العميلة بنفس الشهر — اختاري شهراً آخر',
    'A measurement already exists for this client in the same month — pick another month',
  );
  static String get measurementAddedSuccess =>
      _t('تمت إضافة القياس بنجاح', 'Measurement added successfully');
  static String get measurementsPhotoBefore => _t('صورة قبل', 'Before photo');
  static String get measurementsPhotoAfter => _t('صورة بعد', 'After photo');
  static String get measurementsEmptyHistory =>
      _t('لا يوجد قياسات مسجلة بعد', 'No measurements recorded yet');
  static String get measurementsNotEnoughForProgress => _t(
    'لا توجد بيانات كافية لعرض التقدم',
    'Not enough data to show progress',
  );

  // ── F4 — الإشعارات ─────────────────────────────────────────
  static String get notificationsMarkAllRead =>
      _t('قراءة الكل', 'Mark all read');
  static String get notificationsMarkAsRead =>
      _t('تحديد كمقروء', 'Mark as read');
  static String get notificationsUnreadSection => _t('غير مقروءة', 'Unread');
  static String get notificationsReadSection => _t('مقروءة', 'Read');
  // أمثلة نصوص إشعارات فعلية (تبقى Templates بتتبني ديناميك من الباك إند)
  static String get notificationSubscriptionEndingTemplate => _t(
    'اشتراك {name} ينتهي خلال {days} أيام',
    "{name}'s subscription ends in {days} days",
  );
  static String get notificationMissingMeasurementTemplate => _t(
    '{name} لم تسجل قياساتها هذا الشهر',
    '{name} has not recorded measurements this month',
  );
  static String get notificationNeedsNewProgramTemplate =>
      _t('{name} تحتاج برنامجاً جديداً', '{name} needs a new program');
  static String get notificationGreatProgressTemplate =>
      _t('{name}: تقدم ممتاز هذا الشهر', '{name}: great progress this month');
  static String get timeAgoHour => _t('منذ ساعة', 'An hour ago');
  static String get timeAgoDay => _t('منذ يوم', 'A day ago');
  static String get timeAgoDays3 => _t('منذ 3 أيام', '3 days ago');
  static String get timeAgoWeek => _t('منذ أسبوع', 'A week ago');

  // ── F5 — المالية ───────────────────────────────────────────
  static String get financeIncome => _t('الدخل', 'Income');
  static String get financeExpenses => _t('المصروفات', 'Expenses');
  static String get financeNetProfit => _t('صافي الربح', 'Net profit');
  static String get financeCurrency => _t('ريال', 'SAR');
  static String get financeProfitSplit => _t('قسمة الربح', 'Profit split');
  static String get financeWithdraw => _t('سحب', 'Withdraw');
  static String get financeBalance => _t('الرصيد:', 'Balance:');
  static String get financeAddNewPartner =>
      _t('إضافة طرف جديد', 'Add new partner');

  // ── F6 — تسجيل الدخول ──────────────────────────────────────
  static String get loginWelcomeBack => _t('مرحباً بعودتك', 'Welcome back');
  static String get loginSignInToContinue =>
      _t('سجّلي دخولك للمتابعة', 'Sign in to continue');
  static String get loginEmailLabel => _t('البريد الإلكتروني', 'Email');
  static String get loginPasswordLabel => _t('كلمة المرور', 'Password');
  static String get loginForgotPassword =>
      _t('نسيت كلمة المرور؟', 'Forgot password?');
  static String get loginCta => _t('تسجيل الدخول', 'Log in');
  static String get loginNoAccount =>
      _t('ليس لديك حساب؟', "Don't have an account?");
  static String get loginContactUs => _t('تواصلي معنا', 'Contact us');

  // ── F7 — إضافة عميلة جديدة ─────────────────────────────────
  static String get addClientScreenTitle => _t('عميلة جديدة', 'New client');
  static String get addClientFullNameLabel => _t('الاسم الكامل', 'Full name');
  static String get addClientFullNameHint =>
      _t('اسم العميلة...', 'Client name...');
  static String get addClientPhysicalDataSection =>
      _t('البيانات الجسمانية', 'Physical data');
  static String get addClientGoalSection => _t('الهدف', 'Goal');
  static String get addClientProgramSection => _t('البرنامج', 'Program');
  static String get addClientSubscriptionSection =>
      _t('الاشتراك', 'Subscription');
  static String get addClientAmountLabel => _t('المبلغ (ريال)', 'Amount (SAR)');
  static String get addClientNoteLabel => _t('ملاحظة', 'Note');
  static String get addClientNoteHintExample =>
      _t('مثال: دفعتين...', 'Example: two installments...');
  static String get addClientDateHint => 'dd / mm / yyyy';

  // ── F8 — قياس جديد ─────────────────────────────────────────
  static String get addMeasurementScreenTitle =>
      _t('قياس جديد', 'New measurement');
  static String get addMonthlyMeasurement =>
      _t('إضافة قياس شهري', 'Add monthly measurement');
  static String get addMeasurementMonthLabel => _t('الشهر', 'Month');
  static String get addMeasurementPhotosLabel => _t('الصور', 'Photos');
  static String get saveMeasurementCta => _t('حفظ القياس', 'Save measurement');

  // ── F9 — تعديل ملف العميل ──────────────────────────────────
  static String get editClientScreenTitle =>
      _t('تعديل ملف العميل', 'Edit client profile');
  static String get editClientSaveChangesCta =>
      _t('حفظ التعديلات', 'Save changes');
  static String get editClientDeleteClient =>
      _t('حذف العميلة', 'Delete client');

  // ── F10 — إنشاء حساب جديد ──────────────────────────────────
  static String get signUpWelcomeLetsStart =>
      _t('أهلاً بك، لنبدأ معاً', "Welcome, let's get started");
  static String get signUpScreenTitle =>
      _t('إنشاء حساب جديد', 'Create new account');
  static String get signUpEnterDataToStart =>
      _t('أدخلي بياناتك للبدء', 'Enter your details to start');
  static String get createAccountCta => _t('إنشاء الحساب', 'Create account');
  static String get signUpAlreadyHaveAccount =>
      _t('لديك حساب بالفعل؟', 'Already have an account?');
  static String get signUpSuccessMessage =>
      _t('تم إنشاء الحساب بنجاح', 'Account created successfully');
  static String get signUpConfirmEmailMessage => _t(
    'تم إنشاء الحساب! تحقّقي من بريدك الإلكتروني لتأكيد الحساب قبل تسجيل الدخول',
    'Account created! Check your email to confirm it before logging in',
  );
  static String get loginSuccessMessage =>
      _t('تم تسجيل الدخول بنجاح', 'Logged in successfully');

  //  نصوص التحقق من الصحة (Validation)
  static String get nameRequired =>
      _t('يرجى إدخال الاسم الكامل', 'Please enter the full name');
  static String get emailRequired =>
      _t('يرجى إدخال البريد الإلكتروني', 'Please enter your email');
  static String get invalidEmail =>
      _t('يرجى إدخال بريد إلكتروني صحيح', 'Please enter a valid email');
  static String get passwordRequired =>
      _t('يرجى إدخال كلمة المرور', 'Please enter your password');
  static String get passwordTooShort => _t(
    'كلمة المرور يجب أن لا تقل عن 8 أحرف',
    'Password must be at least 8 characters',
  );
  static String get passwordMissingUppercase => _t(
    'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل (A-Z)',
    'Password must contain at least one uppercase letter (A-Z)',
  );
  static String get passwordMissingLowercase => _t(
    'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل (a-z)',
    'Password must contain at least one lowercase letter (a-z)',
  );
  static String get passwordMissingDigit => _t(
    'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (0-9)',
    'Password must contain at least one digit (0-9)',
  );
  static String get passwordHint => _t(
    '8 أحرف على الأقل، تحتوي على حرف كبير وحرف صغير ورقم',
    'At least 8 characters, with an uppercase, a lowercase and a digit',
  );

  // ── F11 / F12 — نسيت كلمة المرور ───────────────────────────
  static String get forgotPasswordRecoverPassword =>
      _t('استعادة كلمة المرور', 'Recover password');
  static String get forgotPasswordTitle =>
      _t('نسيت كلمة المرور؟', 'Forgot password?');
  static String get forgotPasswordEnterEmailInstructions => _t(
    'أدخلي بريدك الإلكتروني وسنرسل لك رابط الاستعادة',
    'Enter your email and we will send you a recovery link',
  );
  static String get forgotPasswordSendResetLinkCta =>
      _t('إرسال رابط الاستعادة', 'Send recovery link');
  static String get forgotPasswordBackToLogin =>
      _t('العودة لتسجيل الدخول', 'Back to login');

  static String get forgotPasswordLinkSentTitle =>
      _t('تم الإرسال بنجاح', 'Sent successfully');
  static String get forgotPasswordEmailSentHeading =>
      _t('تم الإرسال!', 'Sent!');
  static String get forgotPasswordCheckEmailInstructions => _t(
    'تحقّقي من بريدك الإلكتروني واتّبعي الرابط لإعادة التعيين',
    'Check your email and follow the link to reset it',
  );
  static String get forgotPasswordOpenEmailCta =>
      _t('فتح البريد الإلكتروني', 'Open email');
  static String get forgotPasswordDidNotReceiveEmail =>
      _t('لم تصلك الرسالة؟', "Didn't receive the email?");
  static String get forgotPasswordResend => _t('إعادة الإرسال', 'Resend');

  // ── تعيين كلمة مرور جديدة (تكملة F11 / F12) ────────────────
  static String get resetPasswordTitle => _t('كلمة مرور جديدة', 'New password');
  static String get resetPasswordInstructions => _t(
    'أدخلي كلمة المرور الجديدة الخاصة بحسابك',
    'Enter the new password for your account',
  );
  static String get resetPasswordNewPasswordLabel =>
      _t('كلمة المرور الجديدة', 'New password');
  static String get resetPasswordConfirmPasswordLabel =>
      _t('تأكيد كلمة المرور', 'Confirm password');
  static String get resetPasswordMismatch =>
      _t('كلمتا المرور غير متطابقتين', 'Passwords do not match');
  static String get resetPasswordSubmitCta =>
      _t('حفظ كلمة المرور', 'Save password');

  // ── Subscribers — فورم إضافة/تعديل عميلة (F7 / F9) ─────────
  // نصوص التحقق (Validation) الخاصة بحقول الفورم
  static String get subscriberNameRequired =>
      _t('يرجى إدخال اسم العميلة', "Please enter the client's name");
  static String get subscriberNameTooShort => _t(
    'الاسم يجب أن يحتوي على 3 حروف على الأقل',
    'Name must be at least 3 characters',
  );
  static String get subscriberNameInvalidChars => _t(
    'الاسم يحتوي على رموز غير مسموح بها',
    'Name contains characters that are not allowed',
  );
  static String get fieldRequiredShort => _t('مطلوب', 'Required');
  static String get ageInvalid => _t('عمر غير منطقي', 'Invalid age');
  static String get heightInvalid => _t('طول غير منطقي', 'Invalid height');
  static String get weightInvalid => _t('وزن غير منطقي', 'Invalid weight');
  static String get feeRequired =>
      _t('يرجى إدخال المبلغ', 'Please enter the amount');
  static String get feeInvalid => _t('مبلغ غير صالح', 'Invalid amount');
  static String get noteTooLong => _t(
    'الملاحظة طويلة جداً (يجب ألا تتجاوز 60 حرف)',
    'Note is too long (must not exceed 60 characters)',
  );
  static String get ageUnitYear => _t('سنة', 'yrs');

  static String get subscriptionDatesRequired => _t(
    'يرجى اختيار تاريخ البدء والانتهاء',
    'Please select the start and end dates',
  );
  static String get subscriptionDateOrderInvalid => _t(
    'تاريخ الانتهاء يجب أن يكون بعد تاريخ البدء',
    'End date must be after the start date',
  );

  // رسائل نجاح/تأكيد
  static String get addSubscriberSuccessMessage =>
      _t('تمت إضافة العميلة بنجاح', 'Client added successfully');
  static String get editSubscriberSuccessMessage =>
      _t('تم حفظ التعديلات بنجاح', 'Changes saved successfully');
  static String get deleteSubscriberConfirmMessage => _t(
    'هل أنتِ متأكدة من حذف هذه العميلة؟ لا يمكن التراجع عن هذا الإجراء.',
    'Are you sure you want to delete this client? This action cannot be undone.',
  );

  // قائمة العملاء وشاشة التعديل
  static String get noMatchingClients =>
      _t('لا يوجد عملاء مطابقين', 'No matching clients');
  static String get loadSubscriberError =>
      _t('تعذر تحميل بيانات العميلة', "Couldn't load the client's data");
}
