import 'package:flutter/material.dart';
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
    this.controller, // 👈 أضفنا الكنترولر
    this.obscureText = false, // 👈 أضفنا خيار إخفاء النص (كلمة المرور)
    this.keyboardType, // 👈 أضفنا نوع الكيبورد
    this.validator,
    this.helperText,
    this.autovalidateMode,
  });

  final String title;
  final String hintText;
  final String? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  final String? helperText;
  final AutovalidateMode? autovalidateMode;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = context.appColors.border;
    final textSecondaryColor = context.appColors.textSecondary;

    final effectivePrefixIcon =
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
            : widget.prefixIcon;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.title,
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
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintStyle: AppTextStyles.bodyM.copyWith(color: textSecondaryColor),
            helperText: widget.helperText,
            helperMaxLines: 2,
            helperStyle: AppTextStyles.bodyS.copyWith(
              color: textSecondaryColor,
            ),
            filled: true,
            fillColor: widget.fillColor ?? context.appColors.bgSubtle,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.mdLg,
              vertical: AppSpacing.xl,
            ),
            suffixIcon: widget.suffixIcon,
            prefixIcon: effectivePrefixIcon,
            labelText: widget.label,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: AppBorders.regular,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
