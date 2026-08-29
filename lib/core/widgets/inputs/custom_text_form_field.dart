// lib/core/widgets/inputs/custom_text_form_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glow_up/core/constants/app_borders.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.title,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    this.fillColor,
    this.borderColor, // 👈 لتخصيص لون الحدود بحالات معيّنة (وضع التعديل مثلاً)
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.helperText,
    this.autovalidateMode,
    this.textAlign = TextAlign.right,
    this.inputFormatters,
    this.textDirection,
  });

  final String title;
  final String hintText;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? helperText;
  final AutovalidateMode? autovalidateMode;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;

  /// اتجاه النص جوّا الحقل. لو تُرك null بينتحدد تلقائيًا من
  /// [keyboardType] — شوف [_effectiveTextDirection].
  final TextDirection? textDirection;

  /// الإيميل والأرقام والروابط دايمًا لاتيني، حتى بواجهة عربية. بدون
  /// فرض LTR بيتعامل معهم Flutter كنص RTL: المؤشر بيوقف عالجهة الغلط
  /// و `@`/`.` بيقفزوا لمطارح غريبة أثناء الكتابة.
  TextDirection? get _effectiveTextDirection {
    if (textDirection != null) return textDirection;
    if (obscureText) return TextDirection.ltr;
    final type = keyboardType;
    if (type == null) return null;
    // المقارنة بالـ index مش بالكائن نفسه: `TextInputType.numberWithOptions`
    // بتبني نسخة جديدة مش مطابقة لـ `TextInputType.number` بالمساواة، بس
    // بتشاركها نفس الـ index — وهي المستخدمة بكل حقول الأرقام بالتطبيق.
    return _ltrKeyboardIndices.contains(type.index) ? TextDirection.ltr : null;
  }

  static final Set<int> _ltrKeyboardIndices = {
    TextInputType.emailAddress.index,
    TextInputType.url.index,
    TextInputType.phone.index,
    TextInputType.number.index,
    TextInputType.datetime.index,
    TextInputType.visiblePassword.index,
  };

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final textSecondaryColor = context.appColors.textSecondary;

    final Widget? effectivePrefixIcon =
        widget.obscureText
            ? IconButton(
              icon: Icon(
                _obscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: AppSizes.icon,
                color: textSecondaryColor,
              ),
              onPressed: () => setState(() => _obscured = !_obscured),
            )
            : (widget.prefixIcon != null
                ? IconTheme(
                  data: IconThemeData(color: textSecondaryColor),
                  child: widget.prefixIcon!,
                )
                : null);

    // لو ما تم تمرير borderColor مخصص، منسيب border/enabledBorder فاضيين
    // (null) عشان يجيبوا الافتراضي من AppTheme.inputDecorationTheme —
    // هيك أي تعديل مستقبلي عالثيم بينعكس تلقائيًا هون بدون تغيير الـ widget.
    final OutlineInputBorder? customBorder =
        widget.borderColor != null
            ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: widget.borderColor!,
                width: AppBorders.regular,
              ),
            )
            : null;

    return Column(
      crossAxisAlignment:
          widget.textAlign == TextAlign.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              widget.textAlign == TextAlign.center
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
          children: [
            Text(
              widget.title,
              textAlign: widget.textAlign,
              style: AppTextStyles.bodyM.copyWith(color: textSecondaryColor),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          textAlign: widget.textAlign,
          textDirection: widget._effectiveTextDirection,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            helperText: widget.helperText,
            fillColor: widget.fillColor,
            suffixIcon: widget.suffixIcon,
            prefixIcon: effectivePrefixIcon,
            labelText: widget.label,
            hintText: widget.hintText,
            border: customBorder,
            enabledBorder: customBorder,
          ),
        ),
      ],
    );
  }
}
