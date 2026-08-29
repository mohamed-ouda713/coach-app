import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// صيغ المخاطبة بالمؤنث. التطبيق بيخاطب المستخدم بصيغة محايدة
/// (المذكّر بالعربي بيشتغل كصيغة عامة)، فأي نص جديد بصيغة المؤنث
/// بيوقف هون بدل ما يوصل للشاشة.
const _feminineForms = <String>[
  'سجّلي',
  'سجلي',
  'أدخلي',
  'ادخلي',
  'اختاري',
  'تواصلي',
  'حاولي',
  'تحققي',
  'راجعي',
  'أضيفي',
  'احفظي',
  'جرّبي',
  'جربي',
  'اطلبي',
  'انتظري',
  'املئي',
  'اكتبي',
  'ارفعي',
  'حددي',
  'افتحي',
  'انسخي',
  'العميلة',
  'عميلة',
  'المشتركة',
  'المدربة',
  'مدربة',
  'أنتِ',
  'متأكدة',
  'تودين',
  'لديكِ',
];

/// بتطلّع النص العربي من كل استدعاء `_t('ar', 'en')`.
final _arabicArg = RegExp(r"_t\(\s*'([^']*)'\s*,", dotAll: true);

void main() {
  const files = [
    'lib/core/constants/app_strings.dart',
    'lib/core/errors/error_messages.dart',
  ];

  for (final path in files) {
    test('$path addresses the user in a gender-neutral form', () {
      final source = File(path).readAsStringSync();
      final offenders = <String>[];

      for (final match in _arabicArg.allMatches(source)) {
        final text = match.group(1)!;
        final hit = _feminineForms.where(text.contains).toList();
        if (hit.isNotEmpty) {
          final line =
              '\n'.allMatches(source.substring(0, match.start)).length + 1;
          offenders.add('  line $line: "$text"  → ${hit.join(", ")}');
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'These strings address the user as female. Use the neutral '
            '(masculine) form instead:\n${offenders.join("\n")}',
      );
    });
  }
}
