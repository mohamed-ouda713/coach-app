// lib/features/subscribers/models/subscriber_model.dart

import 'package:equatable/equatable.dart';
import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';

class SubscriberModel extends Equatable {
  const SubscriberModel({
    required this.id,
    required this.trainerId,
    required this.fullName,
    this.age,
    this.weight,
    this.height,
    required this.goal,
    required this.program,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.subscriptionFee,
    this.lastProgramUpdate,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String trainerId;
  final String fullName;
  final int? age;
  final double? weight;
  final double? height;
  final FitnessGoal goal;
  final ProgramType program;
  final DateTime subscriptionStartDate;
  final DateTime subscriptionEndDate;
  final double subscriptionFee;
  final DateTime? lastProgramUpdate;
  final String? note;
  final DateTime createdAt;

  /// بتتحسب دايمًا وقت العرض — مش عمود مخزّن بقاعدة البيانات.
  SubscriptionStatus get status {
    final now = DateTime.now();
    final daysLeft = subscriptionEndDate.difference(now).inDays;

    if (daysLeft < 0) return SubscriptionStatus.expired;
    if (daysLeft <= 3) return SubscriptionStatus.expiringSoon;
    return SubscriptionStatus.active;
  }

  factory SubscriberModel.fromJson(Map<String, dynamic> json) {
    return SubscriberModel(
      id: json[SupabaseColumns.id] as String,
      trainerId: json[SupabaseColumns.trainerId] as String,
      fullName: json[SupabaseColumns.fullName] as String,
      age: json[SupabaseColumns.age] as int?,
      weight: (json[SupabaseColumns.weight] as num?)?.toDouble(),
      height: (json[SupabaseColumns.height] as num?)?.toDouble(),
      goal: _goalFromDb(json[SupabaseColumns.goal] as String),
      program: _programFromDb(json[SupabaseColumns.program] as String),
      subscriptionStartDate:
          DateTime.parse(json[SupabaseColumns.subscriptionStartDate] as String),
      subscriptionEndDate:
          DateTime.parse(json[SupabaseColumns.subscriptionEndDate] as String),
      subscriptionFee: (json[SupabaseColumns.subscriptionFee] as num).toDouble(),
      lastProgramUpdate: json[SupabaseColumns.lastProgramUpdate] != null
          ? DateTime.parse(json[SupabaseColumns.lastProgramUpdate] as String)
          : null,
      note: json[SupabaseColumns.note] as String?,
      createdAt: DateTime.parse(json[SupabaseColumns.createdAt] as String),
    );
  }

  /// بدون id/trainerId/createdAt — دول بتتحدد من السيرفر أو من الـ repository.
  Map<String, dynamic> toInsertJson() {
    return {
      SupabaseColumns.fullName: fullName,
      SupabaseColumns.age: age,
      SupabaseColumns.weight: weight,
      SupabaseColumns.height: height,
      SupabaseColumns.goal: _goalToDb(goal),
      SupabaseColumns.program: _programToDb(program),
      SupabaseColumns.subscriptionStartDate:
          subscriptionStartDate.toIso8601String().split('T').first,
      SupabaseColumns.subscriptionEndDate:
          subscriptionEndDate.toIso8601String().split('T').first,
      SupabaseColumns.subscriptionFee: subscriptionFee,
      SupabaseColumns.lastProgramUpdate:
          lastProgramUpdate?.toIso8601String().split('T').first,
      SupabaseColumns.note: note,
    };
  }

  SubscriberModel copyWith({
    String? fullName,
    int? age,
    double? weight,
    double? height,
    FitnessGoal? goal,
    ProgramType? program,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    double? subscriptionFee,
    DateTime? lastProgramUpdate,
    String? note,
  }) {
    return SubscriberModel(
      id: id,
      trainerId: trainerId,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      goal: goal ?? this.goal,
      program: program ?? this.program,
      subscriptionStartDate: subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      subscriptionFee: subscriptionFee ?? this.subscriptionFee,
      lastProgramUpdate: lastProgramUpdate ?? this.lastProgramUpdate,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        trainerId,
        fullName,
        age,
        weight,
        height,
        goal,
        program,
        subscriptionStartDate,
        subscriptionEndDate,
        subscriptionFee,
        lastProgramUpdate,
        note,
        createdAt,
      ];
}

FitnessGoal _goalFromDb(String value) => switch (value) {
      'weight_loss' => FitnessGoal.weightLoss,
      'muscle_gain' => FitnessGoal.muscleGain,
      'general_fitness' => FitnessGoal.generalFitness,
      'recovery' => FitnessGoal.recovery,
      _ => throw FormatException('Unknown goal value: $value'),
    };

String _goalToDb(FitnessGoal goal) => switch (goal) {
      FitnessGoal.weightLoss => 'weight_loss',
      FitnessGoal.muscleGain => 'muscle_gain',
      FitnessGoal.generalFitness => 'general_fitness',
      FitnessGoal.recovery => 'recovery',
    };

ProgramType _programFromDb(String value) => switch (value) {
      'gym' => ProgramType.gym,
      'home' => ProgramType.home,
      _ => throw FormatException('Unknown program value: $value'),
    };

String _programToDb(ProgramType program) => switch (program) {
      ProgramType.gym => 'gym',
      ProgramType.home => 'home',
    };