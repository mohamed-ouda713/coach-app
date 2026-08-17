import 'package:flutter/material.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'لا توجد إشعارات حالياً',
        style: TextStyle(color: context.appColors.textSecondary, fontSize: AppSizes.iconXxs),
      ),
    );
  }
}
