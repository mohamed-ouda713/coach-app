import 'package:flutter/material.dart';

class NotificationsLoading extends StatelessWidget {
  const NotificationsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // اللون لازم يكون الأساسي مش primarySoftBg — هداك لون خلفية باهت
    // للشارات، والمؤشر فيه بيصير شبه مخفي على الخلفية الفاتحة.
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
