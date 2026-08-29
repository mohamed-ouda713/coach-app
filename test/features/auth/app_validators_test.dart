import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/features/auth/helper/app_validators.dart';

void main() {
  group('validateEmail', () {
    test('accepts a normal address', () {
      expect(AppValidators.validateEmail('coach@example.com'), isNull);
    });

    test('trims surrounding whitespace before validating', () {
      expect(AppValidators.validateEmail('  coach@example.com  '), isNull);
    });

    test('rejects an empty value', () {
      expect(AppValidators.validateEmail(''), AppStrings.emailRequired);
      expect(AppValidators.validateEmail(null), AppStrings.emailRequired);
    });

    test('rejects a malformed address', () {
      expect(AppValidators.validateEmail('coach@'), AppStrings.invalidEmail);
      expect(AppValidators.validateEmail('coach.com'), AppStrings.invalidEmail);
    });

    test('rejects disposable domains regardless of case', () {
      expect(
        AppValidators.validateEmail('a@Mailinator.com'),
        AppStrings.tempEmailNotAllowed,
      );
    });
  });

  group('validatePassword', () {
    test('accepts a password meeting every rule', () {
      expect(AppValidators.validatePassword('Passw0rdd'), isNull);
    });

    test('rejects fewer than 8 characters', () {
      expect(
        AppValidators.validatePassword('Pas0'),
        AppStrings.passwordTooShort,
      );
    });

    test('requires an uppercase letter', () {
      expect(
        AppValidators.validatePassword('passw0rdd'),
        AppStrings.passwordMissingUppercase,
      );
    });

    test('requires a lowercase letter', () {
      expect(
        AppValidators.validatePassword('PASSW0RDD'),
        AppStrings.passwordMissingLowercase,
      );
    });

    test('requires a digit', () {
      expect(
        AppValidators.validatePassword('Passworddd'),
        AppStrings.passwordMissingDigit,
      );
    });
  });

  group('validateName', () {
    test('rejects blank input', () {
      expect(AppValidators.validateName('   '), AppStrings.nameRequired);
    });

    test('accepts a real name', () {
      expect(AppValidators.validateName('سما'), isNull);
    });
  });
}
