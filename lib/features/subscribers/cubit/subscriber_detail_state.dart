// lib/features/subscribers/cubit/subscriber_detail_state.dart

import 'package:equatable/equatable.dart';
import '../models/subscriber_model.dart';

sealed class SubscriberDetailState extends Equatable {
  const SubscriberDetailState();

  @override
  List<Object?> get props => [];
}

class SubscriberDetailInitial extends SubscriberDetailState {
  const SubscriberDetailInitial();
}

class SubscriberDetailLoading extends SubscriberDetailState {
  const SubscriberDetailLoading();
}

class SubscriberDetailLoaded extends SubscriberDetailState {
  const SubscriberDetailLoaded(this.subscriber);

  final SubscriberModel subscriber;

  @override
  List<Object?> get props => [subscriber];
}

class SubscriberDetailError extends SubscriberDetailState {
  const SubscriberDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
