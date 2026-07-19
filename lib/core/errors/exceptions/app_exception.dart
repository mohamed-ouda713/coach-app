/// الكلاس الأساسي (base) لكل الاستثناءات المخصصة بالتطبيق.
///
/// كل استثناء مخصص (Network, Auth, Database, Storage, Validation)
/// بيرث من هاد الكلاس ولازم يجهّز [message] جاهز بالعربي وقت الإنشاء —
/// هيك أي مكان بالكود بيمسك AppException بيقدر ياخد `.message` مباشرة
/// بدون ما يعرف نوع الاستثناء بالتحديد.
abstract class AppException implements Exception {
  const AppException(this.message);

  /// رسالة جاهزة بالعربي، مفهومة للمستخدم النهائي (تُعرض مباشرة بالـ UI).
  final String message;

  @override
  String toString() => message;
}
