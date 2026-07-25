import 'package:flutter/material.dart';
import '../../constants/app_enums.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/context_extensions.dart';
import '../media/app_avatar.dart';
import '../status/badges.dart';

/// بطاقة عرض عميلة بالقائمة (F1) — أفاتار + اسم + شارة هدف + شارة حالة + سهم.
class ClientCard extends StatelessWidget {
  const ClientCard({
    super.key,
    required this.name,
    required this.goal,
    required this.status,
    this.imageUrl,
    this.gradientColors = const [
      AppColors.categoryBlueStart,
      AppColors.categoryBlueEnd,
    ],
    this.onTap,
  });

  final String name;
  final FitnessGoal goal;
  final SubscriptionStatus status;
  final String? imageUrl;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.clientCard),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lgAlt,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.clientCard),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            AppAvatar(name: name, imageUrl: imageUrl, gradientColors: gradientColors),
            const SizedBox(width: AppSpacing.mdLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.h5.copyWith(color: colorScheme.onSurface)),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      GoalBadge(goal: goal),
                      const SizedBox(width: AppSpacing.xs),
                      StatusBadge(status: status),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left, size: AppSizes.iconMd, color: appColors.textDisabled),
          ],
        ),
      ),
    );
  }
}
