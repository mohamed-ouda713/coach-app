import 'package:flutter/material.dart';

class NotificationsError extends StatelessWidget {
  final String message;

  const NotificationsError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
    child: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
    );
  }
}
