import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';

class SignupFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool enabled;
  const SignupFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.enabled,
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

        // 1️⃣ حقل الاسم الكامل
        CustomTextFormField(
         controller: widget.nameController,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return AppStrings.nameRequired;
            }
            return null;
          },
          suffixIcon: const Icon(
            Icons.person,
            size: AppSizes.icon,
            color: AppColorsDark.textSecondary,
          ),
          fillColor: Colors.transparent,
          title: AppStrings.addClientFullNameLabel,
          hintText: AppStrings.addClientFullNameLabel,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 2️⃣ حقل البريد الإلكتروني
        CustomTextFormField(
          controller: widget.emailController,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return AppStrings.emailRequired;
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          suffixIcon: const Icon(
            Icons.email_outlined,
            size: AppSizes.icon,
            color: AppColorsDark.textSecondary,
          ),
          fillColor: Colors.transparent,
          title: AppStrings.loginEmailLabel,
          hintText: AppStrings.loginEmailLabel,
        ),
        const SizedBox(height: AppSpacing.lg),

        // 3️⃣ حقل كلمة المرور
        CustomTextFormField(
          controller: widget.passwordController,
          obscureText: true,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return AppStrings.passwordRequired;
            }
            if (v.length < 6) {
              return AppStrings.passwordTooShort;
            }
            return null;
          },
          prefixIcon: const Icon(
            Icons.visibility_outlined,
            size: AppSizes.icon,
            color: AppColorsDark.textSecondary,
          ),
          suffixIcon: const Icon(
            Icons.lock_outline,
            size: AppSizes.icon,
            color: AppColorsDark.textSecondary,
          ),
          fillColor: Colors.transparent,
          title: AppStrings.loginPasswordLabel,
          hintText: AppStrings.loginPasswordLabel,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
