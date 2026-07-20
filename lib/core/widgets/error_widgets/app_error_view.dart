import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'إعادة المحاولة',
    this.icon = Icons.error_outline_rounded,
  });

  /// رسالة الخطأ الجاهزة للعرض.
  final String message;

  /// دالة تُستدعى عند الضغط على زر إعادة المحاولة.
  /// لو تُترك null، الزر ما بيظهر (مثلاً لخطأ نهائي بدون إعادة محاولة).
  final VoidCallback? onRetry;

  final String retryLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final danger = isDark ? AppColorsDark.danger : AppColorsLight.danger;
    final dangerBg = isDark ? AppColorsDark.dangerBg : AppColorsLight.dangerBg;
    final textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final primarySoftBg = isDark ? AppColorsDark.primarySoftBg : AppColorsLight.primarySoftBg;
    
    // ✅ تحسين التباين: تحديد لون النص والأيقونة بداخل الزر ديناميكياً لتفادي اختفائه في الـ Dark Mode
    final buttonContentColor = isDark ? Colors.white : AppColors.primaryDark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // الأيقونة التنبيهية الكبيرة للواجهة
            Container(
              width: AppSizes.avatarLogo,
              height: AppSizes.avatarLogo,
              decoration: BoxDecoration(
                color: dangerBg,
                borderRadius: BorderRadius.circular(AppRadius.iconCircleXl),
              ),
              child: Icon(icon, size: AppSizes.iconDisplay, color: danger),
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // رسالة الخطأ
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(color: textPrimary),
            ),
            
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              // ✅ تحسين الحجم: وضع ConstrainedBox لضمان أبعاد متناسقة ومتوازنة للزر دائماً
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 160, // حد أدنى لشكل أنيق
                  maxWidth: 240, // حد أقصى لمنع تمدده المشوه على شاشات التابلت
                ),
                child: SizedBox(
                  height: AppSizes.buttonHeightSm,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySoftBg,
                      foregroundColor: buttonContentColor, // استخدام المتغير الديناميكي هنا
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: AppSizes.icon),
                    label: Text(retryLabel, style: AppTextStyles.buttonM),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}