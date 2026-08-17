import 'package:flutter/material.dart';
import 'package:glow_up/core/theme/context_extensions.dart';

class NotificationsLoading extends StatelessWidget {
  const NotificationsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.appColors.primarySoftBg),
    );
  }
}
