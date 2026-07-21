import 'package:flutter/material.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class AppErrorSnackbar {
  AppErrorSnackbar._();

  static void show(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: appColors.dangerBg,
          elevation: 0,
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lgAlt,
            vertical: AppSpacing.lgAlt,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          content: Row(
            children: [
              Icon(
                Icons.error_outline_rounded, 
                size: AppSizes.icon, 
                color: colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyM.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}