import 'package:glow_up/core/constants/app_strings.dart';

abstract class AppRegex {
  static final RegExp emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  static final RegExp uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp digitRegex = RegExp(r'[0-9]');
}

abstract class AppValidators {
  static const List<String> _blockedDomains = [
    'tempmail.com',
    'mailinator.com',
    '10minutemail.com',
    'guerrillamail.com',
    'dispostable.com',
  ];

  static String? validateName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    return null;
  }

  static String? validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!AppRegex.emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    if (value.contains('@')) {
      final domain = value.split('@').last.toLowerCase();
      if (_blockedDomains.contains(domain)) {
        return AppStrings.tempEmailNotAllowed;
      }
    }
    return null;
  }

  static String? validatePassword(String? v) {
    if (v == null || v.trim().isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (v.length < 8) {
      return AppStrings.passwordTooShort;
    }
    if (!AppRegex.uppercaseRegex.hasMatch(v)) {
      return AppStrings.passwordMissingUppercase;
    }
    if (!AppRegex.lowercaseRegex.hasMatch(v)) {
      return AppStrings.passwordMissingLowercase;
    }
    if (!AppRegex.digitRegex.hasMatch(v)) {
      return AppStrings.passwordMissingDigit;
    }
    return null;
  }
}
