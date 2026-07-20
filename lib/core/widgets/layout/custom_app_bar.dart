import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.height = AppSizes.inputHeight, 
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: نستبدلهم بألوان الـ Theme لما تنضاف الحقول الناقصة لـ AppTheme.
    final Color bg = isDark ? AppColorsDark.bgCard : AppColorsLight.bgCard;
    final Color textPrimary =
        isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
    final Color textTertiary =
        isDark ? AppColorsDark.textTertiary : AppColorsLight.textTertiary;

    final titleWidget = subtitle == null
        ? Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h4.copyWith(
              color: textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h4.copyWith(
                  color: textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs / 2), 
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.tiny.copyWith(color: textTertiary),
              ),
            ],
          );

    return SafeArea(
      bottom: false,
      child: Container(
        color: bg,
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;

            final double maxSideWidth = availableWidth * 0.30;
            final double minTitleSpace = availableWidth * 0.25;

            final double effectiveMaxSideWidth =
                (availableWidth - minTitleSpace) / 2;

            final double maxWidth = maxSideWidth < effectiveMaxSideWidth
                ? maxSideWidth
                : effectiveMaxSideWidth;

            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding * 2,
                      ),
                      child: titleWidget,
                    ),
                  ),
                ),

                PositionedDirectional(
                  start: AppSpacing.xs, 
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: maxWidth,
                      ),
                      child: leading != null 
                          ? Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: leading,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),

                PositionedDirectional(
                  end: AppSpacing.xs,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd, 
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 0,
                        maxWidth: maxWidth,
                      ),
                      // ✅ الحل الصحيح: استخدام Align مع centerEnd للتثبيت على الحافة والتوسيط العمودي فقط
                      child: actions != null
                          ? Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: actions!,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}