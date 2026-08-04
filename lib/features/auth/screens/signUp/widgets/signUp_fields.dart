import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_card.dart';

class SignupFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool enabled;
  final String? errorMessage;
  const SignupFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.enabled,
    this.errorMessage,
  });

  @override
  State<SignupFields> createState() => _SignupFieldsState();
}

class _SignupFieldsState extends State<SignupFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        if (widget.errorMessage != null) ...[
          AppErrorCard(message: widget.errorMessage),
          const SizedBox(height: AppSpacing.lg),
        ],

        // 1️⃣ حقل الاسم الكامل
        CustomTextFormField(
          controller: widget.nameController,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return AppStrings.nameRequired;
            }
            return null;
          },
          suffixIcon: Icon(
            Icons.person,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.addClientFullNameLabel,
          hintText: AppStrings.addClientFullNameLabel,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 2️⃣ حقل البريد الإلكتروني
        CustomTextFormField(
          controller: widget.emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) {
            final value = v?.trim() ?? '';
            if (value.isEmpty) {
              return AppStrings.emailRequired;
            }
            if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(value)) {
              return AppStrings.invalidEmail;
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          suffixIcon: Icon(
            Icons.email_outlined,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.loginEmailLabel,
          hintText: AppStrings.loginEmailLabel,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 3️⃣ حقل كلمة المرور
        CustomTextFormField(
          controller: widget.passwordController,
          obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return AppStrings.passwordRequired;
            }
            if (v.length < 8) {
              return AppStrings.passwordTooShort;
            }
            if (!v.contains(RegExp(r'[A-Z]'))) {
              return AppStrings.passwordMissingUppercase;
            }
            if (!v.contains(RegExp(r'[a-z]'))) {
              return AppStrings.passwordMissingLowercase;
            }
            if (!v.contains(RegExp(r'[0-9]'))) {
              return AppStrings.passwordMissingDigit;
            }
            return null;
          },
          helperText: AppStrings.passwordHint,
          prefixIcon: Icon(
            Icons.visibility_outlined,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          suffixIcon: Icon(
            Icons.lock_outline,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          title: AppStrings.loginPasswordLabel,
          hintText: AppStrings.loginPasswordLabel,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
