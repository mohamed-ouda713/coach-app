class UserMetadataKeys {
  UserMetadataKeys._();

  static const String fullName = 'full_name';
}

/// روابط الـ deep link يلي بيرجعلها Supabase بعد ما المستخدم يدوس
/// على رابط بالإيميل — لازم تكون نفسها مسجّلة بـ AndroidManifest.xml
/// و Info.plist، وكمان مضافة لـ Redirect URLs بإعدادات مشروع Supabase.
class AuthRedirectUrls {
  AuthRedirectUrls._();

  static const String passwordRecovery = 'com.glowup.glowup://reset-callback/';
}