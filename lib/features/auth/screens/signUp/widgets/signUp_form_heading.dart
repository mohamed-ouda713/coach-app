import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

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
          style: AppTextStyles.h1.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.signUpEnterDataToStart,
          style: AppTextStyles.bodyM.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
