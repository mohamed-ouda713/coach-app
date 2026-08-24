import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = context.appColors;

    final Color bg = colorScheme.surface;
    final Color textPrimary = colorScheme.onSurface;
    final Color textTertiary = appColors.textTertiary;

    final titleWidget =
        subtitle == null
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

    const double sidePadding = AppSpacing.lgAlt;

    return SafeArea(
      bottom: false,
      child: Container(
        color: bg,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. العنوان في المنتصف مع حماية المسافة الجانبية حتى لا يتداخل مع الأزرار
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding * 2 + 40,
                  ),
                  child: titleWidget,
                ),
              ),
            ),

            // 2. جهة البداية (Leading) - يأخذ العرض الأدنى فقط الحاضن لمحتواه
            PositionedDirectional(
              start: sidePadding,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: UnconstrainedBox(
                  child: leading ?? const SizedBox.shrink(),
                ),
              ),
            ),

            // 3. جهة النهاية (Actions)
            PositionedDirectional(
              end: sidePadding,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child:
                    actions != null && actions!.isNotEmpty
                        ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions!,
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
