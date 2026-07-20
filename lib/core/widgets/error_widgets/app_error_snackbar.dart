import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppErrorSnackbar {
  AppErrorSnackbar._();

  static void show(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final danger = isDark ? AppColorsDark.danger : AppColorsLight.danger;
    final dangerBg = isDark ? AppColorsDark.dangerBg : AppColorsLight.dangerBg;
    
    // تنظيف: جلب لون نص أساسي واضح أو استخدام لون داكن/فاتح صريح لضمان التباين العالي وقابلية القراءة
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: dangerBg,
          elevation: 0,
          duration: const Duration(seconds: 3),
          // تحسين UX: السماح للمستخدم بسحب السناكبر أفقياً لإخفائه فوراً إذا كان يغطي عنصراً مهماً
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
                color: danger,
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyM.copyWith(
                    color: isDark ? Colors.white : textPrimary, // تحسين: تباين لوني مريح للعين
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