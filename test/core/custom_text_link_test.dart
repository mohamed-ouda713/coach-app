import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/widgets/buttons/custom_text_link.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(body: child),
    ),
  );

  testWidgets('tapping the label fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(CustomTextLink(title: 'نسيت كلمة المرور؟', onPressed: () => taps++)),
    );

    await tester.tap(find.text('نسيت كلمة المرور؟'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('the tap target is at least 44pt tall', (tester) async {
    await tester.pumpWidget(
      wrap(CustomTextLink(title: 'رابط', onPressed: () {})),
    );

    final size = tester.getSize(find.byType(CustomTextLink));
    expect(
      size.height,
      greaterThanOrEqualTo(AppSizes.minTapTarget),
      reason: 'links smaller than 44pt are hard to hit on a phone',
    );
  });

  testWidgets('padding around the label is tappable, not just the glyphs', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(CustomTextLink(title: 'رابط', onPressed: () => taps++)),
    );

    // نقطة قريبة من حافة مساحة اللمس، فوق النص نفسه بشوي.
    final rect = tester.getRect(find.byType(CustomTextLink));
    await tester.tapAt(Offset(rect.center.dx, rect.top + 3));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('renders inside a bottom-anchored Positioned card', (
    tester,
  ) async {
    // نفس بنية شاشة الدخول: Stack خارجي، وبطاقة موضوعة بـ Positioned.
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        Stack(
          children: [
            Container(color: Colors.blue),
            Stack(
              children: [
                Positioned(
                  top: 200,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 300),
                          CustomTextLink(
                            title: 'تواصلي معنا',
                            onPressed: () => taps++,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('تواصلي معنا'));
    await tester.pump();

    expect(taps, 1, reason: 'the card sits above the header in the Stack');
  });
}
