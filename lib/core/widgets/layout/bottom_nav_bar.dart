import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart'; // تأكد من المسار الصحيح للـ Spacing في مشروعك
import '../../constants/app_borders.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
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

  static const _items = [
    (icon: Icons.people_outline, label: AppStrings.navClients),
    (icon: Icons.straighten, label: AppStrings.navMeasurements),
    (icon: Icons.notifications_none, label: AppStrings.navNotifications),
    (icon: Icons.account_balance_wallet_outlined, label: AppStrings.navFinances),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: نستبدلهم بألوان الـ Theme لما تنضاف الحقول الناقصة لـ AppTheme.
    final Color bg = isDark ? AppColorsDark.bgCard : AppColorsLight.bgCard;
    final Color border = isDark ? AppColorsDark.border : AppColorsLight.border;
    final Color activeBg = isDark ? AppColorsDark.primarySoftBg : AppColorsLight.primarySoftBg;
    final Color inactiveColor = isDark ? AppColorsDark.textTertiary : AppColorsLight.textTertiary;

    return Container(
      height: AppSizes.bottomNavHeight,
      // تنظيف: استبدال الرقم الثابت 8 بـ AppSpacing.sm
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
          final currentColor = isActive ? AppColors.primary : inactiveColor;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(AppRadius.md),
              highlightColor: Colors.transparent,
              splashColor: AppColors.primary.withOpacity(0.08), // تأثير لمس خفيف وناعم
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // تنظيف: استخدام AnimatedContainer لإعطاء سلاسة فخمة أثناء التنقل بين الأزرار
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
                  // تنظيف: استبدال الرقم السحري 3 بمسافة نسبية من نظام المسافات
                  const SizedBox(height: AppSpacing.xs / 2),
                  Text(
                    item.label,
                    style: AppTextStyles.tiny.copyWith(
                      color: currentColor,
                    ),
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