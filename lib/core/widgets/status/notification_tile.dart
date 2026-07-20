import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart'; // تأكد من المسار الصحيح للـ Spacing
import '../../constants/app_enums.dart';
import '../../constants/app_radius.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// عنصر إشعار واحد بقائمة الإشعارات — أيقونة، لون، ونقطة صغيرة
/// حسب نوع الإشعار، بالإضافة لحالة "مقروء" (يقلل الشفافية ويخفي النقطة).
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.type,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
  });

  final NotificationType type;
  final String message;
  final String timeAgo;

  /// لو true: الكرت بيصير شفاف شوي والنقطة بتختفي كليًا —
  /// مطابق لما التصميم بيسميه "Success (read)".
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: نستبدلهم بـ Theme.of(context).colorScheme.surface لما تنضاف الحقول الناقصة لـ AppTheme.
    final Color cardBg = isDark ? AppColorsDark.bgCard : AppColorsLight.bgCard;
    final Color textPrimary = isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final Color textSecondary = isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

    final (icon, iconColor, iconBg) = switch (type) {
      NotificationType.subscriptionExpiry => (
          Icons.notifications,
          AppColors.primary,
          isDark ? AppColorsDark.primarySoftBg : AppColorsLight.primarySoftBg,
        ),
      NotificationType.overdueMeasurement => (
          Icons.show_chart,
          isDark ? AppColorsDark.warning : AppColorsLight.warning,
          isDark ? AppColorsDark.warningBg : AppColorsLight.warningBg,
        ),
      NotificationType.newProgramNeeded => (
          Icons.account_box,
          isDark ? AppColorsDark.info : AppColorsLight.info,
          isDark ? AppColorsDark.infoBg : AppColorsLight.infoBg,
        ),
      NotificationType.progressUpdate => (
          Icons.check,
          isDark ? AppColorsDark.success : AppColorsLight.success,
          isDark ? AppColorsDark.successBg : AppColorsLight.successBg,
        ),
    };

    // تحسين الأداء: تطبيق الشفافية على الألوان بدلاً من استخدام ويدجت Opacity المكلفة برمجياً
    final double currentOpacity = isRead ? 0.55 : 1.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md), // تنظيف: استخدام نظام المسافات بدلاً من 16
      decoration: BoxDecoration(
        color: cardBg.withOpacity(currentOpacity),
        borderRadius: BorderRadius.circular(AppRadius.clientCard),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isRead ? 0.02 : 0.05), 
            blurRadius: 12, 
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBg.withOpacity(currentOpacity), 
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              size: 20, 
              color: iconColor.withOpacity(currentOpacity),
            ),
          ),
          const SizedBox(width: AppSpacing.md), // تنظيف: استبدال الـ 12 بـ md
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: AppTextStyles.h5.copyWith(
                    color: textPrimary.withOpacity(currentOpacity),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs), // تنظيف: استبدال الـ 5 بـ xs
                Text(
                  timeAgo,
                  style: AppTextStyles.caption.copyWith(
                    color: textSecondary.withOpacity(currentOpacity),
                  ),
                ),
              ],
            ),
          ),
          if (!isRead) ...[
            const SizedBox(width: AppSpacing.md), // تنظيف: استبدال الـ 12 بـ md
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: AppSpacing.xs / 2), // تنظيف: استبدال الرقم السحري 3 بمسافة نسبية
              decoration: BoxDecoration(
                color: iconColor, 
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}