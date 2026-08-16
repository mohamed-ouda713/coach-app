import 'package:glow_up/core/localization/app_locale.dart';

/// كل رسائل الخطأ الجاهزة المعروضة للمستخدم (عربي/إنجليزي).
///
/// مركّزة بمكان واحد عشان:
/// 1) لو حبينا نعدّل صياغة رسالة، نعدلها بمكان واحد بس.
/// 2) الترجمة بتنحل من هون حسب اللغة المختارة بصفحة حسابي.
class ErrorMessages {
  ErrorMessages._();

  static String _t(String ar, String en) => AppLocale.t(ar, en);

  // ── عامة ───────────────────────────────────────────────
  static String get unexpected => _t(
    'حدث خطأ غير متوقع، حاول مرة أخرى',
    'An unexpected error occurred, please try again',
  );
  static String get tryAgainLater => _t(
    'حدث خطأ، حاول مرة أخرى لاحقاً',
    'Something went wrong, please try again later',
  );

  // ── شبكة (Network) ─────────────────────────────────────
  static String get noInternet => _t(
    'لا يوجد اتصال بالإنترنت، تحقق من الشبكة',
    'No internet connection, please check your network',
  );
  static String get requestTimeout => _t(
    'استغرق الطلب وقتاً طويلاً، حاول مرة أخرى',
    'The request took too long, please try again',
  );
  static String get serverUnreachable => _t(
    'تعذر الوصول إلى الخادم حالياً',
    'The server is unreachable right now',
  );

  // ── مصادقة (Auth) ───────────────────────────────────────
  static String get invalidCredentials => _t(
    'البريد الإلكتروني أو كلمة المرور غير صحيحة',
    'Incorrect email or password',
  );
  static String get emailAlreadyInUse =>
      _t('هذا البريد الإلكتروني مستخدم مسبقاً', 'This email is already in use');
  static String get emailNotAvailable => _t(
    'لا يمكن استخدام هذا البريد الإلكتروني، جرّبي بريداً آخر',
    'This email cannot be used, please try another one',
  );
  static String get weakPassword => _t(
    'كلمة المرور ضعيفة، اختر كلمة مرور أقوى',
    'Password is too weak, choose a stronger one',
  );
  static String get emailNotConfirmed => _t(
    'يرجى تأكيد بريدك الإلكتروني أولاً',
    'Please confirm your email first',
  );
  static String get sessionExpired => _t(
    'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
    'Your session expired, please log in again',
  );
  static String get emailRateLimitExceeded => _t(
    'تم إرسال عدد كبير من رسائل التحقق، حاول مرة أخرى بعد قليل',
    'Too many verification emails sent, please try again shortly',
  );
  static String get authGeneric => _t(
    'حدث خطأ أثناء تسجيل الدخول، حاول مرة أخرى',
    'An error occurred while logging in, please try again',
  );

  // ── قاعدة البيانات (Database) ───────────────────────────
  static String get duplicateEntry =>
      _t('هذا السجل موجود مسبقاً', 'This record already exists');
  static String get recordNotFound => _t(
    'لم يتم العثور على البيانات المطلوبة',
    'The requested data was not found',
  );
  static String get foreignKeyViolation => _t(
    'لا يمكن الحذف لوجود بيانات مرتبطة',
    'Cannot delete because related data exists',
  );
  static String get permissionDenied => _t(
    'ليس لديك صلاحية لتنفيذ هذا الإجراء',
    "You don't have permission to perform this action",
  );
  static String get databaseGeneric => _t(
    'حدث خطأ أثناء التعامل مع البيانات',
    'An error occurred while handling the data',
  );

  // ── تخزين الصور (Storage) ───────────────────────────────
  static String get fileTooLarge => _t(
    'حجم الصورة كبير جداً، اختر صورة أصغر',
    'The image is too large, choose a smaller one',
  );
  static String get uploadFailed =>
      _t('فشل رفع الصورة، حاول مرة أخرى', 'Image upload failed, try again');
  static String get fileNotFound => _t('الصورة غير موجودة', 'Image not found');
  static String get storageGeneric => _t(
    'حدث خطأ أثناء رفع أو جلب الصورة',
    'An error occurred while uploading or fetching the image',
  );

  // ── تحقق من الإدخال (Validation) ────────────────────────
  static String get requiredField =>
      _t('هذا الحقل مطلوب', 'This field is required');
  static String get invalidEmail =>
      _t('صيغة البريد الإلكتروني غير صحيحة', 'Invalid email format');
  static String get invalidPhone =>
      _t('رقم الهاتف غير صحيح', 'Invalid phone number');
  static String get passwordTooShort => _t(
    'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
    'Password must be at least 6 characters',
  );
  static String get validationGeneric => _t(
    'يرجى التحقق من البيانات المدخلة',
    'Please check the information you entered',
  );
}
