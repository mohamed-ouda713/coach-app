import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_borders.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
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
    this.validator, this.formKey, // 👈 أضفنا الـ validator لو حابب تفعل الـ Validation
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
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    const borderColor = AppColorsDark.border;
    const primaryColor = AppColors.primary;
    const textSecondaryColor = AppColorsDark.textSecondary;

    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyM.copyWith(color: textSecondaryColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintStyle: AppTextStyles.bodyM.copyWith(color: textSecondaryColor),
              filled: true,
              fillColor: fillColor ?? AppColorsDark.bgCard,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.mdLg,
                vertical: AppSpacing.xl,
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              labelText: label,
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: AppBorders.regular,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}