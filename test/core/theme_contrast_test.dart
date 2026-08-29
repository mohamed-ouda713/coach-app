import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/theme/app_colors_extension.dart';
import 'package:glow_up/core/theme/app_theme.dart';

/// نسبة التباين حسب WCAG — 4.5:1 هو الحد الأدنى للنص العادي.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  const minReadable = 4.5;

  test('link colour is readable on the light surface', () {
    final surface = AppTheme.light.colorScheme.surface;
    final ratio = contrast(AppColorsExtension.light.link, surface);

    expect(
      ratio,
      greaterThanOrEqualTo(minReadable),
      reason:
          'AppColors.primary is only 2.77:1 on white — link text needs the '
          'darker shade. Got ${ratio.toStringAsFixed(2)}:1',
    );
  });

  test('link colour is readable on the dark surface', () {
    final surface = AppTheme.dark.colorScheme.surface;
    final ratio = contrast(AppColorsExtension.dark.link, surface);

    expect(
      ratio,
      greaterThanOrEqualTo(minReadable),
      reason: 'got ${ratio.toStringAsFixed(2)}:1',
    );
  });

  test('secondary body text is readable in both themes', () {
    expect(
      contrast(
        AppColorsExtension.light.textSecondary,
        AppTheme.light.colorScheme.surface,
      ),
      greaterThanOrEqualTo(minReadable),
    );
    expect(
      contrast(
        AppColorsExtension.dark.textSecondary,
        AppTheme.dark.colorScheme.surface,
      ),
      greaterThanOrEqualTo(minReadable),
    );
  });
}
