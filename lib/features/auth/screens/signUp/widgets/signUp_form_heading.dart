import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class SignupFormHeading extends StatelessWidget {
  const SignupFormHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.signUpScreenTitle,
          style: AppTextStyles.h1.copyWith(color: AppColorsDark.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.signUpEnterDataToStart,
          style: AppTextStyles.bodyM.copyWith(
            color: AppColorsDark.textSecondary,
          ),
        ),
      ],
    );
  }
}
