// lib/core/widgets/inputs/search_widget.dart

import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
  });

  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  /// شكل هالحقل (pill كامل، بدون حدود) مختلف قصداً عن
  /// AppTheme.inputDecorationTheme العام (المستطيل بحدود، مستخدم بـ
  /// CustomTextFormField) — فمش هون مكانه الصح بالثيم المشترك.
  /// لو ظهر حقل بحث تاني بنفس الشكل بمكان تاني بالتطبيق، وقتها ينقل
  /// لهيلبر/ثيم مشترك؛ حالياً استخدام واحد بس فمنسيبه محلي هون.
  static const _noBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
    borderSide: BorderSide.none,
  );

  static const _iconTapSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.start,
      style: AppTextStyles.bodyM.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText ?? AppStrings.clientsSearchHint,
        hintStyle: AppTextStyles.bodyM.copyWith(color: colors.textSecondary),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppSpacing.md,
            end: AppSpacing.xs,
          ),
          child: Icon(
            Icons.search,
            color: colors.textSecondary,
            size: AppSizes.icon,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: _iconTapSize,
          minHeight: _iconTapSize,
        ),
        border: _noBorder,
        enabledBorder: _noBorder,
        focusedBorder: _noBorder,
      ),
    );
  }
}