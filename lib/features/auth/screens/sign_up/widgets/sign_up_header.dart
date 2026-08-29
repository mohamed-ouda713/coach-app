import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/widgets/media/app_avatar.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.primary,
        ),

        // 2️⃣ الهيدر واللوجو
        Positioned(
          top:
              MediaQuery.of(context).size.height *
              AppSizes.authHeaderTopFraction,
          left: 0,
          right: 0,
          child: Column(
            children: [
              AppAvatar(name: AppStrings.appName),
              Text(
                AppStrings.appName,
                style: AppTextStyles.display.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.signUpWelcomeLetsStart,
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
