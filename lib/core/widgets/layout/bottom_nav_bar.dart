import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import '../../constants/app_borders.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_text_styles.dart';

/// شريط التنقل السفلي الثابت — العملاء / القياسات / الإشعارات / المالية.
/// غير مستخدم بشاشات الـ Auth (F6 ← F12).
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static List<({IconData icon, String label})> get _items => [
    (icon: Icons.people, label: AppStrings.navClients),
    (icon: Icons.bar_chart, label: AppStrings.navMeasurements),
    (icon: Icons.notifications, label: AppStrings.navNotifications),
    (icon: Icons.attach_money, label: AppStrings.navFinances),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final Color bg = colorScheme.surface;
    final Color border = appColors.border;
    final Color activeBg = appColors.primarySoftBg;
    final Color inactiveColor = appColors.textTertiary;

    return Container(
      height: AppSizes.bottomNavHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: AppBorders.thin)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final isActive = index == currentIndex;
          final item = _items[index];
          final currentColor = isActive ? colorScheme.primary : inactiveColor;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(AppRadius.md),
              highlightColor: Colors.transparent,
              splashColor: colorScheme.primary.withOpacity(0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 48,
                    height: AppSizes.toggleHeight,
                    decoration: BoxDecoration(
                      color: isActive ? activeBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      item.icon,
                      size: AppSizes.icon,
                      color: currentColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs / 2),
                  Text(
                    item.label,
                    style: AppTextStyles.tiny.copyWith(color: currentColor),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
