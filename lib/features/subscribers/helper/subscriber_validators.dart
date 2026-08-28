// lib/features/subscribers/helper/subscriber_validators.dart

import 'package:glow_up/core/constants/app_strings.dart';

/// حدود التحقق الخاصة بحقول فورم العميلة (F7 / F9) — بمكان واحد
/// عشان أي تعديل بالقيم المسموحة يصير بسطر واحد، بدل ما يكون
/// متفرق كأرقام "سايبة" (magic numbers) جوا الشاشة.
abstract class SubscriberFormLimits {
  SubscriberFormLimits._();

  static const int nameMinLength = 3;
  static const int nameMaxLength = 50;

  static const int minAge = 5;
  static const int maxAge = 100;

  static const double minHeight = 50;
  static const double maxHeight = 250;

  static const double minWeight = 20;
  static const double maxWeight = 300;

  static const int noteMaxLength = 60;
}

/// كل الـ Validators الخاصة بفورم إضافة/تعديل عميلة، بمكان واحد
/// بدل ما تكون مكررة ومبعثرة جوا [SubscriberFormScreen] نفسها.
abstract class SubscriberValidators {
  SubscriberValidators._();

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.subscriberNameRequired;
    if (trimmed.length < SubscriberFormLimits.nameMinLength) {
      return AppStrings.subscriberNameTooShort;
    }
    if (RegExp(r'[<>{}\/\\]').hasMatch(trimmed)) {
      return AppStrings.subscriberNameInvalidChars;
    }
    return null;
  }

  static String? age(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.fieldRequiredShort;
    final age = int.tryParse(trimmed);
    if (age == null ||
        age < SubscriberFormLimits.minAge ||
        age > SubscriberFormLimits.maxAge) {
      return AppStrings.ageInvalid;
    }
    return null;
  }

  static String? height(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.fieldRequiredShort;
    final height = double.tryParse(trimmed);
    if (height == null ||
        height < SubscriberFormLimits.minHeight ||
        height > SubscriberFormLimits.maxHeight) {
      return AppStrings.heightInvalid;
    }
    return null;
  }

  static String? weight(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.fieldRequiredShort;
    final weight = double.tryParse(trimmed);
    if (weight == null ||
        weight < SubscriberFormLimits.minWeight ||
        weight > SubscriberFormLimits.maxWeight) {
      return AppStrings.weightInvalid;
    }
    return null;
  }

  static String? fee(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return AppStrings.feeRequired;
    final fee = double.tryParse(trimmed);
    if (fee == null || fee < 0) return AppStrings.feeInvalid;
    return null;
  }

  /// الملاحظة اختيارية — فاضية = صحيحة.
  static String? note(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    if (trimmed.length > SubscriberFormLimits.noteMaxLength) {
      return AppStrings.noteTooLong;
    }
    return null;
  }
}
