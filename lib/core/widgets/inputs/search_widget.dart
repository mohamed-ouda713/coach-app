// lib/core/widgets/inputs/search_widget.dart

import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface, // 👈 النص المكتوب باللون الأسود/الأساسي للتطبيق
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText ?? AppStrings.clientsSearchHint,
        hintStyle: TextStyle(
          color: colors.textSecondary,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface, // خلفية بيضاء صافية
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
            size: 20,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}