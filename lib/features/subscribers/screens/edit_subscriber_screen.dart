// lib/features/subscribers/screens/edit_subscriber_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_view.dart';
import '../cubit/subscriber_cubit.dart';
import '../cubit/subscriber_detail_cubit.dart';
import '../cubit/subscriber_detail_state.dart';
import 'subscriber_form_screen.dart';

/// بتجيب العميل بنفسها بالـ id عبر SubscriberDetailCubit محلي (نفس نمط
/// ClientProfileScreen)، وتمررها جاهزة لـ SubscriberFormScreen بوضع التعديل.
class EditSubscriberScreen extends StatelessWidget {
  const EditSubscriberScreen({super.key, required this.subscriberId});

  final String subscriberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SubscriberDetailCubit(context.read<SubscriberCubit>())
                ..load(subscriberId),
      child: Scaffold(
        body: BlocBuilder<SubscriberDetailCubit, SubscriberDetailState>(
          builder: (context, state) {
            return switch (state) {
              SubscriberDetailInitial() || SubscriberDetailLoading() =>
                const Center(child: CircularProgressIndicator()),
              SubscriberDetailError(:final message) => AppErrorView(
                message: message,
                onRetry:
                    () => context.read<SubscriberDetailCubit>().load(
                      subscriberId,
                    ),
              ),
              SubscriberDetailLoaded(:final subscriber) => SubscriberFormScreen(
                initialSubscriber: subscriber,
              ),
            };
          },
        ),
      ),
    );
  }
}
