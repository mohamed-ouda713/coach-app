// lib/core/constants/app_date_formats.dart

import 'package:intl/intl.dart';

import 'package:glow_up/core/localization/app_locale.dart';

/// تنسيقات التاريخ الجاهزة المستخدمة بأكتر من مكان بالتطبيق — بمكان
/// واحد عشان ما يتكرر نفس الـ `DateFormat('...')` بكل شاشة لحالها،
/// ولو احتجنا نغيّر شكل عرض تاريخ معيّن، نعرف بالضبط وين نلاقيه.
abstract class AppDateFormats {
  AppDateFormats._();

  /// "dd / MM / yyyy" — حقول اختيار التاريخ بالفورمات (تواريخ الاشتراك).
  static final inputField = DateFormat('dd / MM / yyyy');

  /// "1 يونيو 2025" — تاريخ كامل، مستخدم بعرض تفاصيل الاشتراك.
  /// getter (مش قيمة محسوبة مرة وحدة) عشان يواكب تبديل اللغة وقت التشغيل.
  static DateFormat get fullDate => DateFormat('d MMMM yyyy', AppLocale.code);
}