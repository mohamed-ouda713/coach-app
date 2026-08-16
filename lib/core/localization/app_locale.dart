import 'package:flutter/material.dart';

class AppLocale {
  AppLocale._();

  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  static const List<Locale> supported = [arabic, english];

  static Locale current = arabic;

  static String get code => current.languageCode;

  static bool get isEnglish => current.languageCode == 'en';

  static String t(String ar, String en) => isEnglish ? en : ar;
}
