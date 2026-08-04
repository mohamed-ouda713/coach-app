/// كل رسائل الخطأ الجاهزة بالعربي المعروضة للمستخدم.
///
/// مركّزة بمكان واحد عشان:
/// 1) لو حبينا نعدّل صياغة رسالة، نعدلها بمكان واحد بس.
/// 2) لو انتقلنا لـ localization بالمستقبل، هاد أول ملف بننقل منه.
class ErrorMessages {
  ErrorMessages._();

  // ── عامة ───────────────────────────────────────────────
  static const String unexpected = 'حدث خطأ غير متوقع، حاول مرة أخرى';
  static const String tryAgainLater = 'حدث خطأ، حاول مرة أخرى لاحقاً';

  // ── شبكة (Network) ─────────────────────────────────────
  static const String noInternet = 'لا يوجد اتصال بالإنترنت، تحقق من الشبكة';
  static const String requestTimeout =
      'استغرق الطلب وقتاً طويلاً، حاول مرة أخرى';
  static const String serverUnreachable = 'تعذر الوصول إلى الخادم حالياً';

  // ── مصادقة (Auth) ───────────────────────────────────────
  static const String invalidCredentials =
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';
  static const String emailAlreadyInUse = 'هذا البريد الإلكتروني مستخدم مسبقاً';
  static const String emailNotAvailable =
      'لا يمكن استخدام هذا البريد الإلكتروني، جرّبي بريداً آخر';
  static const String weakPassword = 'كلمة المرور ضعيفة، اختر كلمة مرور أقوى';
  static const String emailNotConfirmed = 'يرجى تأكيد بريدك الإلكتروني أولاً';
  static const String sessionExpired =
      'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى';
  static const String emailRateLimitExceeded =
      'تم إرسال عدد كبير من رسائل التحقق، حاول مرة أخرى بعد قليل';
  static const String authGeneric = 'حدث خطأ أثناء تسجيل الدخول، حاول مرة أخرى';

  // ── قاعدة البيانات (Database) ───────────────────────────
  static const String duplicateEntry = 'هذا السجل موجود مسبقاً';
  static const String recordNotFound = 'لم يتم العثور على البيانات المطلوبة';
  static const String foreignKeyViolation = 'لا يمكن الحذف لوجود بيانات مرتبطة';
  static const String permissionDenied = 'ليس لديك صلاحية لتنفيذ هذا الإجراء';
  static const String databaseGeneric = 'حدث خطأ أثناء التعامل مع البيانات';

  // ── تخزين الصور (Storage) ───────────────────────────────
  static const String fileTooLarge = 'حجم الصورة كبير جداً، اختر صورة أصغر';
  static const String uploadFailed = 'فشل رفع الصورة، حاول مرة أخرى';
  static const String fileNotFound = 'الصورة غير موجودة';
  static const String storageGeneric = 'حدث خطأ أثناء رفع أو جلب الصورة';

  // ── تحقق من الإدخال (Validation) ────────────────────────
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidEmail = 'صيغة البريد الإلكتروني غير صحيحة';
  static const String invalidPhone = 'رقم الهاتف غير صحيح';
  static const String passwordTooShort =
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  static const String validationGeneric = 'يرجى التحقق من البيانات المدخلة';
}
