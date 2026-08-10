import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_colors.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/widgets/media/app_avatar.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Stack(
      children: [
        // 1️⃣ خلفية الجزء العلوي
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.primary,
        ),

        // 2️⃣ الهيدر واللوجو
        Positioned(
          top: MediaQuery.of(context).size.height * 0.08,
          left: 0,
          right: 0,
          child: Column(
            children: [
              AppAvatar(name: AppStrings.appName),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.appName,
                style: AppTextStyles.display.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.tagline,
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
