import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/context_extensions.dart';
import '../media/app_avatar.dart';

class HomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeTopBar({
    super.key,
    required this.userName,
    this.onProfileTap,
    this.onAddTap,
    this.onNotificationsTap,
    this.hasUnreadNotifications = false,
  });

  final String userName;
  final VoidCallback? onProfileTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onNotificationsTap;
  final bool hasUnreadNotifications;

  static const double height = 84;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgAlt),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onProfileTap,
                    borderRadius: BorderRadius.circular(AppRadius.badge),
                    child: Row(
                      children: [
                        AppAvatar(name: userName, size: AvatarSize.small),
                        const SizedBox(width: AppSpacing.mdLg),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.homeWelcomeGreeting,
                                style: AppTextStyles.bodyS.copyWith(
                                  color: context.appColors.textTertiary,
                                ),
                              ),
                              Text(
                                userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.h2.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _TopBarActionButton(
                  icon: Icons.add,
                  tooltip: AppStrings.homeAddTooltip,
                  backgroundColor: colorScheme.primary,
                  iconColor: colorScheme.onPrimary,
                  onTap: onAddTap,
                ),
                const SizedBox(width: AppSpacing.smMd),
                _TopBarActionButton(
                  icon: Icons.notifications,
                  tooltip: AppStrings.homeNotificationsTooltip,
                  backgroundColor: context.appColors.bgSubtle,
                  iconColor: colorScheme.onSurface.withOpacity(0.5),
                  onTap: onNotificationsTap,
                  showBadge: hasUnreadNotifications,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBarActionButton extends StatelessWidget {
  const _TopBarActionButton({
    required this.icon,
    required this.tooltip,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool showBadge;

  static const double _size = AppSizes.inputHeightSm;
  static const double _badgeSize = 10;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: _size,
        height: _size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.cardLg),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Center(
                  child: Icon(icon, size: AppSizes.iconXxl0, color: iconColor),
                ),
              ),
            ),
            if (showBadge)
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: Container(
                  width: _badgeSize,
                  height: _badgeSize,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
