import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, this.hintText});
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.mdLg,
        vertical: AppSpacing.mdLg,
      ),
      decoration: BoxDecoration(
        color: colors.bgSubtle,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: colors.textSecondary, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.lg,
                ),
                hintText: hintText ?? AppStrings.clientsSearchHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
