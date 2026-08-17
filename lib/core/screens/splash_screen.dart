import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarker,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/splash/splash_logo.png',
              width: AppSizes.splashLogo,
              height: AppSizes.splashLogo,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const CircularProgressIndicator(color: AppColors.white),
            const SizedBox(height: AppSpacing.lgAlt),
            Text(
              AppStrings.checkingSession,
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
