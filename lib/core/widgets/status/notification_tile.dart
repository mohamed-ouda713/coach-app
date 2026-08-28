import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import '../../constants/app_enums.dart';
import '../../constants/app_radius.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final Color cardBg = colorScheme.surface;
    final Color textPrimary = colorScheme.onSurface;
    final Color textSecondary = appColors.textSecondary;

    final (icon, iconColor, iconBg) = switch (type) {
      NotificationType.subscriptionExpiry => (
        Icons.notifications,
        colorScheme.primary,
        appColors.primarySoftBg,
      ),
      NotificationType.overdueMeasurement => (
        Icons.show_chart,
        appColors.warning,
        appColors.warningBg,
      ),
      NotificationType.newProgramNeeded => (
        Icons.account_box,
        appColors.info,
        appColors.infoBg,
      ),
      NotificationType.progressUpdate => (
        Icons.check,
        appColors.success,
        appColors.successBg,
      ),
    };

    final double currentOpacity = isRead ? 0.55 : 1.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
          const SizedBox(width: AppSpacing.md),
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
                const SizedBox(height: AppSpacing.xs),
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
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: AppSpacing.xs / 2),
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
