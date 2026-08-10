// lib/features/subscribers/screens/edit_subscriber_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/widgets/async/app_future_builder.dart';
import '../cubit/subscriber_cubit.dart';
import '../models/subscriber_model.dart';
import 'subscriber_form_screen.dart';

/// بتجيب العميلة بنفسها بالـ id (نفس نمط ClientProfileScreen)،
/// وتمررها جاهزة لـ SubscriberFormScreen بوضع التعديل.
class EditSubscriberScreen extends StatefulWidget {
  const EditSubscriberScreen({super.key, required this.subscriberId});

  final String subscriberId;

  @override
  State<EditSubscriberScreen> createState() => _EditSubscriberScreenState();
}

class _EditSubscriberScreenState extends State<EditSubscriberScreen> {
  late Future<SubscriberModel> _future;

  @override
  void initState() {
    super.initState();
    _future =
        context.read<SubscriberCubit>().fetchSubscriberById(widget.subscriberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppFutureBuilder<SubscriberModel>(
        future: _future,
        errorMessage: AppStrings.loadSubscriberError,
        builder: (context, subscriber) =>
            SubscriberFormScreen(initialSubscriber: subscriber),
      ),
    );
  }
}