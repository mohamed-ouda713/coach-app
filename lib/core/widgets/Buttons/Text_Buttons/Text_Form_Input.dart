// lib/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart

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
    this.borderColor, // 👈 أضفنا خاصية لون الحدود
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.helperText,
    this.autovalidateMode,
    this.textAlign = TextAlign.right,
    this.inputFormatters,
  });

  final String title;
  final String hintText;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? borderColor; // 👈 المتغير الجديد
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? helperText;
  final AutovalidateMode? autovalidateMode;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // إن تم تمرير borderColor نستخدمه، وإلا نرجع للون الافتراضي
    final effectiveBorderColor = widget.borderColor ?? context.appColors.border;
    final textSecondaryColor = context.appColors.textSecondary;

    final Widget? effectivePrefixIcon = widget.obscureText
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

    return Column(
      crossAxisAlignment: widget.textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: widget.textAlign == TextAlign.center
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
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintStyle: AppTextStyles.bodyM.copyWith(color: textSecondaryColor),
            helperText: widget.helperText,
            helperMaxLines: 2,
            helperStyle: AppTextStyles.bodyS.copyWith(
              color: textSecondaryColor,
            ),
            filled: true,
            fillColor: widget.fillColor ?? Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xl,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: widget.suffixIcon,
            prefixIcon: effectivePrefixIcon,
            labelText: widget.label,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: effectiveBorderColor,
                width: widget.borderColor != null ? 1.5 : 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: effectiveBorderColor,
                width: widget.borderColor != null ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: AppBorders.regular,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: AppBorders.regular,
              ),
            ),
            errorStyle: AppTextStyles.bodyS.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}