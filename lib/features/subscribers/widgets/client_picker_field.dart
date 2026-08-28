import 'package:flutter/material.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/context_extensions.dart';
import '../models/subscriber_model.dart';

class ClientPickerField extends StatelessWidget {
  const ClientPickerField({
    super.key,
    required this.subscribers,
    required this.value,
    required this.onChanged,
  });

  final List<SubscriberModel> subscribers;
  final SubscriberModel? value;
  final ValueChanged<SubscriberModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.measurementsPickClientLabel,
          style: AppTextStyles.bodyM.copyWith(color: appColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<SubscriberModel>(
          initialValue: value,
          isExpanded: true,
          items:
              subscribers
                  .map(
                    (subscriber) => DropdownMenuItem(
                      value: subscriber,
                      child: Text(subscriber.fullName),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          hint: Text(AppStrings.measurementsPickClientLabel),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: appColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: appColors.border),
            ),
          ),
        ),
      ],
    );
  }
}
