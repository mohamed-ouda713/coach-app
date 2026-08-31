import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class CustomTextLink extends StatelessWidget {
  CustomTextLink({
    super.key,
    this.color,
    required this.title,
    this.icon,
    this.onPressed,
    this.textButton,
    this.textColor,
    this.iconColor,
    this.textButtonColor,
    this.underline = false,
  }) : assert(
         title.trim().isNotEmpty ||
             (textButton != null && textButton.trim().isNotEmpty) ||
             icon != null,
         'CustomTextLink بحاجة لمحتوى مرئي واحد ع الأقل: title غير فاضي، '
         'أو textButton غير فاضي، أو icon.',
       );

  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final String title;
  final String? textButton;
  final IconData? icon;
  final Color? textButtonColor;

  /// بتحط خط تحت [title] (الجزء القابل للضغط) عشان يبان كرابط.
  /// [textButton] بيضل بدون خط لأنه نص تمهيدي مش جزء من الرابط.
  ///
  /// مطفية افتراضيًا: نفس الودجت مستخدمة كزر إجراء بالشريط العلوي
  /// (إضافة/تعديل/رجوع) وهناك الخط بيبيّن غلط. منشغّلها بروابط التنقل
  /// النصية بشاشات الدخول والتسجيل.
  final bool underline;

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).colorScheme.primary;
    final effectiveTextButtonColor = textButtonColor ?? defaultColor;
    final effectiveTextColor = textColor ?? defaultColor;
    final effectiveIconColor = iconColor ?? defaultColor;

    final hasTextButton = textButton != null && textButton!.isNotEmpty;

    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        // النص لحاله ارتفاعه ~20 نقطة — أصغر من الحد الأدنى لمساحة اللمس،
        // فالرابط كان بيحتاج ضغطة دقيقة عشان يشتغل. منفرض ارتفاع أدنى
        // شفاف بدل ما نغيّر شكل النص، و MainAxisSize.min بيضل يمنع الصف
        // من التمدد على عرض الشاشة.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Icon(icon, color: effectiveIconColor, size: AppSizes.icon),
                ],

                // 1. النص الفرعي (إن وجد)
                if (hasTextButton) ...[
                  Text(
                    textButton!,
                    style: AppTextStyles.buttonM.copyWith(
                      color: effectiveTextButtonColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],

                // 2. العنوان الرئيسي — هو الرابط نفسه
                Text(
                  title,
                  style: AppTextStyles.buttonM.copyWith(
                    color: effectiveTextColor,
                    decoration:
                        underline
                            ? TextDecoration.underline
                            : TextDecoration.none,
                    decorationColor: effectiveTextColor,
                    // مسافة صغيرة بين النص والخط بدل ما يلزق بالحروف
                    // النازلة بالعربي.
                    decorationThickness: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
