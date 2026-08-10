// lib/features/subscribers/cubit/subscriber_state.dart

import 'package:equatable/equatable.dart';
import '../models/subscriber_model.dart';

sealed class SubscriberState extends Equatable {
  const SubscriberState();

  @override
  List<Object?> get props => [];
}

class SubscriberInitial extends SubscriberState {
  const SubscriberInitial();
}

class SubscriberLoading extends SubscriberState {
  const SubscriberLoading();
}

class SubscriberLoaded extends SubscriberState {
  const SubscriberLoaded(this.subscribers);

  final List<SubscriberModel> subscribers;

  @override
  List<Object?> get props => [subscribers];
}

class SubscriberError extends SubscriberState {
  const SubscriberError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SubscriberActionInProgress extends SubscriberState {
  const SubscriberActionInProgress(this.subscribers);

  final List<SubscriberModel> subscribers;

  @override
  List<Object?> get props => [subscribers];
}

class SubscriberActionSuccess extends SubscriberState {
  const SubscriberActionSuccess(this.subscribers);

  final List<SubscriberModel> subscribers;

  @override
  List<Object?> get props => [subscribers];
}