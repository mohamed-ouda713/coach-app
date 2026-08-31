// lib/features/subscribers/models/subscriber_model.dart

import 'package:equatable/equatable.dart';
import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/supabase_constants.dart';

/// قيمة حارس لـ [SubscriberModel.copyWith] — بتميّز "ما مرّرت الحقل"
/// عن "مرّرته بقيمة null عشان ينمسح".
const Object _unset = Object();

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
  ///
  /// المقارنة بالأيام التقويمية مش بالساعات: `subscription_end_date`
  /// عمود تاريخ بلا وقت، فبينقرأ كمنتصف الليل. لو طرحنا الوقت الحالي
  /// منه، اشتراك بينتهي اليوم بيطلع بالسالب وبيبان "منتهي" من الصبح.
  SubscriptionStatus get status {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(
      subscriptionEndDate.year,
      subscriptionEndDate.month,
      subscriptionEndDate.day,
    );
    final daysLeft = endDay.difference(today).inDays;

    if (daysLeft < 0) return SubscriptionStatus.expired;
    if (daysLeft <= SubscriptionThresholds.expiringSoonDays) {
      return SubscriptionStatus.expiringSoon;
    }
    return SubscriptionStatus.active;
  }

  /// الاشتراك لسا شغّال (لا فرق إذا كان قريب من الانتهاء).
  ///
  /// [status] بترجع حالة وحدة، و`expiringSoon` بتخفي إنه الاشتراك
  /// لسا نشط — فعميل بينتهي اشتراكه بعد يومين كان بينحسب "غير نشط"
  /// بعدّاد الشاشة الرئيسية وبينشال من فلتر "نشط". "ينتهي قريباً"
  /// تحذير على اشتراك شغّال، مش حالة بديلة عنه.
  bool get isActive => status != SubscriptionStatus.expired;

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
      subscriptionStartDate: DateTime.parse(
        json[SupabaseColumns.subscriptionStartDate] as String,
      ),
      subscriptionEndDate: DateTime.parse(
        json[SupabaseColumns.subscriptionEndDate] as String,
      ),
      subscriptionFee:
          (json[SupabaseColumns.subscriptionFee] as num).toDouble(),
      lastProgramUpdate:
          json[SupabaseColumns.lastProgramUpdate] != null
              ? DateTime.parse(
                json[SupabaseColumns.lastProgramUpdate] as String,
              )
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

  /// الحقول الاختيارية (age/weight/height/note/lastProgramUpdate) بتقبل
  /// المسح الصريح: `copyWith(note: null)` بالنمط العادي بيحافظ على القيمة
  /// القديمة بدل ما يمسحها، فمنستخدم قيمة حارس بدل `null` عشان نميّز
  /// "ما مرّرت شي" عن "امسح هالحقل".
  SubscriberModel copyWith({
    String? fullName,
    Object? age = _unset,
    Object? weight = _unset,
    Object? height = _unset,
    FitnessGoal? goal,
    ProgramType? program,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    double? subscriptionFee,
    Object? lastProgramUpdate = _unset,
    Object? note = _unset,
  }) {
    return SubscriberModel(
      id: id,
      trainerId: trainerId,
      fullName: fullName ?? this.fullName,
      age: identical(age, _unset) ? this.age : age as int?,
      weight: identical(weight, _unset) ? this.weight : weight as double?,
      height: identical(height, _unset) ? this.height : height as double?,
      goal: goal ?? this.goal,
      program: program ?? this.program,
      subscriptionStartDate:
          subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      subscriptionFee: subscriptionFee ?? this.subscriptionFee,
      lastProgramUpdate:
          identical(lastProgramUpdate, _unset)
              ? this.lastProgramUpdate
              : lastProgramUpdate as DateTime?,
      note: identical(note, _unset) ? this.note : note as String?,
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
