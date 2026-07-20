import 'package:flutter/material.dart';

import '../../constants/app_borders.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppErrorDialog extends StatelessWidget {
  const AppErrorDialog({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.error_outline_rounded,
    this.confirmLabel = 'حسناً',
    this.cancelLabel,
    this.isDestructive = false,
  });

  final String? title;
  final String message;
  final IconData icon;
  final String confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;

  static Future<bool?> show(
    BuildContext context, {
    required String message,
    String? title,
    IconData icon = Icons.error_outline_rounded,
    String confirmLabel = 'حسناً',
    String? cancelLabel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: cancelLabel == null,
      builder: (_) => AppErrorDialog(
        title: title,
        message: message,
        icon: icon,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // الألوان الأساسية
    final Color bgCard = isDark ? AppColorsDark.bgCard : AppColorsLight.bgCard;
    final Color border = isDark ? AppColorsDark.border : AppColorsLight.border;
    final Color textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final Color textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    // تنظيف: جعل لون الخلفية العلوية والأيقونة يتغير ديناميكياً بناءً على نوع التنبيه (Destructive أم خطأ عادي/تأكيد)
    final Color dangerColor = isDark ? AppColorsDark.danger : AppColorsLight.danger;
    final Color dangerBgColor = isDark ? AppColorsDark.dangerBg : AppColorsLight.dangerBg;
    
    final Color headerIconColor = isDestructive ? dangerColor : AppColors.primary;
    final Color headerBgColor = isDestructive ? dangerBgColor : AppColors.primary.withOpacity(0.12);

    final hasCancel = cancelLabel != null;

    return Dialog(
      backgroundColor: bgCard,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardLg),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxxl,
          AppSpacing.xxxl,
          AppSpacing.xxxl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الأيقونة العلوية المميزة
            Container(
              width: AppSizes.avatarMd,
              height: AppSizes.avatarMd,
              decoration: BoxDecoration(
                color: headerBgColor, 
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppSizes.iconXxl, color: headerIconColor),
            ),
            const SizedBox(height: AppSpacing.lgAlt),
            
            // محتوى النصوص (مع حماية ضد الـ Overflow للأخطاء الطويلة)
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3.copyWith(color: textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.smMd),
                    ],
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyM.copyWith(color: textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // أزرار التحكم السفلى
            Row(
              children: [
                if (hasCancel) ...[
                  Expanded(
                    child: SizedBox(
                      height: AppSizes.buttonHeightSm,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border, width: AppBorders.regular),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.card),
                          ),
                        ),
                        child: Text(
                          cancelLabel!,
                          style: AppTextStyles.buttonM.copyWith(color: textPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.smMd),
                ],
                Expanded(
                  child: SizedBox(
                    height: AppSizes.buttonHeightSm,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDestructive ? dangerColor : AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.card),
                        ),
                      ),
                      child: Text(confirmLabel, style: AppTextStyles.buttonM),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}