import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:glow_up/core/constants/app_enums.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/custom_icon_button.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_dialog.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_snackbar.dart';
import 'package:glow_up/core/widgets/layout/custom_app_bar.dart';
import 'package:glow_up/core/widgets/selection/selectable_chip.dart';
import 'package:glow_up/core/widgets/status/app_success_snackbar.dart';
import 'package:glow_up/features/subscribers/cubit/subscriber_state.dart';
import 'package:glow_up/features/subscribers/helper/subscriber_validators.dart';

import '../cubit/subscriber_cubit.dart';
import '../models/subscriber_model.dart';

class SubscriberFormScreen extends StatefulWidget {
  const SubscriberFormScreen({super.key, this.initialSubscriber});

  final SubscriberModel? initialSubscriber;

  bool get isEditMode => initialSubscriber != null;

  @override
  State<SubscriberFormScreen> createState() => _SubscriberFormScreenState();
}

class _SubscriberFormScreenState extends State<SubscriberFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _feeController;
  late final TextEditingController _noteController;

  late FitnessGoal _selectedGoal;
  late ProgramType _selectedProgram;
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isSubmitting = false;

  /// بيضل false لحد أول محاولة حفظ — عشان ما يبلّش الفورم يتحقق
  /// من كل الحقول تلقائيًا بمجرد ما تكتبي بحقل واحد بس.
  bool _autovalidate = false;

  static final _dateFormat = DateFormat('dd / MM / yyyy');

  @override
  void initState() {
    super.initState();
    final existing = widget.initialSubscriber;

    _nameController = TextEditingController(text: existing?.fullName ?? '');
    _ageController = TextEditingController(
      text: existing?.age?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: existing?.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: existing?.weight?.toString() ?? '',
    );
    _feeController = TextEditingController(
      text:
          existing?.subscriptionFee != 0
              ? existing?.subscriptionFee.toString() ?? ''
              : '',
    );
    _noteController = TextEditingController(text: existing?.note ?? '');

    _selectedGoal = existing?.goal ?? FitnessGoal.weightLoss;
    _selectedProgram = existing?.program ?? ProgramType.gym;
    _startDate = existing?.subscriptionStartDate;
    _endDate = existing?.subscriptionEndDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _feeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final initial = (isStartDate ? _startDate : _endDate) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    setState(() {
      if (isStartDate) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _onSave() async {
    FocusScope.of(context).unfocus();
    setState(() => _autovalidate = true);

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    if (_startDate == null || _endDate == null) {
      AppErrorSnackbar.show(context, AppStrings.subscriptionDatesRequired);
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      AppErrorSnackbar.show(context, AppStrings.subscriptionDateOrderInvalid);
      return;
    }

    setState(() => _isSubmitting = true);

    final cubit = context.read<SubscriberCubit>();
    final subscriber = _buildSubscriberModel();

    if (widget.isEditMode) {
      await cubit.updateSubscriber(subscriber);
    } else {
      await cubit.addSubscriber(subscriber);
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final state = cubit.state;
    if (state is SubscriberError) {
      AppErrorSnackbar.show(context, state.message);
      return;
    }

    AppSuccessSnackbar.show(
      context,
      widget.isEditMode
          ? AppStrings.editSubscriberSuccessMessage
          : AppStrings.addSubscriberSuccessMessage,
    );
    Navigator.of(context).pop();
  }

  SubscriberModel _buildSubscriberModel() {
    final existing = widget.initialSubscriber;

    return SubscriberModel(
      id: existing?.id ?? '',
      trainerId: existing?.trainerId ?? '',
      fullName: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      height: double.tryParse(_heightController.text.trim()),
      weight: double.tryParse(_weightController.text.trim()),
      goal: _selectedGoal,
      program: _selectedProgram,
      subscriptionStartDate: _startDate!,
      subscriptionEndDate: _endDate!,
      subscriptionFee: double.tryParse(_feeController.text.trim()) ?? 0,
      lastProgramUpdate: existing?.lastProgramUpdate,
      note:
          _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
  }

  Future<void> _onDelete() async {
    final confirmed = await AppErrorDialog.show(
      context,
      title: AppStrings.editClientDeleteClient,
      message: AppStrings.deleteSubscriberConfirmMessage,
      confirmLabel: AppStrings.editClientDeleteClient,
      cancelLabel: AppStrings.dialogCancel,
      isDestructive: true,
    );
    if (confirmed != true) return;
    if (!mounted) return;

    final cubit = context.read<SubscriberCubit>();
    await cubit.deleteSubscriber(widget.initialSubscriber!.id);

    if (!mounted) return;
    final state = cubit.state;
    if (state is SubscriberError) {
      AppErrorSnackbar.show(context, state.message);
      return;
    }

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final editFillColor =
        widget.isEditMode
            ? context.appColors.primarySoftBg
            : theme.colorScheme.surface;
    final editBorderColor = widget.isEditMode ? primaryColor : null;

    return Scaffold(
      backgroundColor: context.appColors.bgSubtle,
      appBar: CustomAppBar(
        title:
            widget.isEditMode
                ? AppStrings.editClientScreenTitle
                : AppStrings.addClientScreenTitle,
        leading: _SaveChip(
          label:
              widget.isEditMode
                  ? AppStrings.editClientSaveChangesCta
                  : AppStrings.actionSave,
          isLoading: _isSubmitting,
          onTap: _onSave,
        ),
        actions: [
          CustomIconButton(
            icon: Icons.close,
            color: theme.colorScheme.primaryContainer.withOpacity(0.08),
            iconColor: context.appColors.textSecondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          autovalidateMode:
              _autovalidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lgAlt),
            children: [
              // 1. الاسم الكامل
              CustomTextFormField(
                title: AppStrings.addClientFullNameLabel,
                hintText: AppStrings.addClientFullNameHint,
                prefixIcon: const Icon(Icons.person, size: 16),
                controller: _nameController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    SubscriberFormLimits.nameMaxLength,
                  ),
                ],
                fillColor: editFillColor,
                borderColor: editBorderColor,
                validator: SubscriberValidators.name,
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. البيانات البدنية (العمر، الطول، الوزن)
              _SectionLabel(AppStrings.addClientPhysicalDataSection),
              const SizedBox(height: AppSpacing.smMd),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العمر
                  Expanded(
                    child: CustomTextFormField(
                      title: AppStrings.clientAge,
                      hintText: '—',
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      suffixIcon: const _UnitLabel(AppStrings.ageUnitYear),
                      fillColor: editFillColor,
                      borderColor: editBorderColor,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: SubscriberValidators.age,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.smMd),

                  // الطول
                  Expanded(
                    child: CustomTextFormField(
                      title: AppStrings.clientHeight,
                      hintText: '—',
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      suffixIcon: _UnitLabel(AppStrings.unitCm),
                      fillColor: editFillColor,
                      borderColor: editBorderColor,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: SubscriberValidators.height,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.smMd),

                  // الوزن
                  Expanded(
                    child: CustomTextFormField(
                      title: AppStrings.clientWeight,
                      hintText: '—',
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      suffixIcon: _UnitLabel(AppStrings.unitKg),
                      fillColor: editFillColor,
                      borderColor: editBorderColor,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                        LengthLimitingTextInputFormatter(5),
                      ],
                      validator: SubscriberValidators.weight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 3. الهدف والبرنامج
              _SectionLabel(AppStrings.addClientGoalSection),
              const SizedBox(height: AppSpacing.smMd),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _goalChip(FitnessGoal.weightLoss, AppStrings.goalWeightLoss),
                  _goalChip(FitnessGoal.muscleGain, AppStrings.goalMuscleGain),
                  _goalChip(
                    FitnessGoal.generalFitness,
                    AppStrings.goalGeneralFitness,
                  ),
                  _goalChip(FitnessGoal.recovery, AppStrings.goalRecovery),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              _SectionLabel(AppStrings.addClientProgramSection),
              const SizedBox(height: AppSpacing.smMd),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  _programChip(ProgramType.gym, AppStrings.programGym),
                  _programChip(ProgramType.home, AppStrings.programHome),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // 4. تواريخ الاشتراك والرسوم والملاحظة
              _SectionLabel(AppStrings.addClientSubscriptionSection),
              const SizedBox(height: AppSpacing.smMd),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: AppStrings.subscriptionStartDate,
                      date: _startDate,
                      dateFormat: _dateFormat,
                      isEditMode: widget.isEditMode,
                      onTap: () => _pickDate(isStartDate: true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.smMd),
                  Expanded(
                    child: _DateField(
                      label: AppStrings.subscriptionEndDate,
                      date: _endDate,
                      dateFormat: _dateFormat,
                      isEditMode: widget.isEditMode,
                      onTap: () => _pickDate(isStartDate: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.smMd),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // مبلغ الاشتراك
                  Expanded(
                    flex: 7,
                    child: CustomTextFormField(
                      title: AppStrings.addClientAmountLabel,
                      hintText: '0.00',
                      controller: _feeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      fillColor: editFillColor,
                      borderColor: editBorderColor,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                        LengthLimitingTextInputFormatter(7),
                      ],
                      validator: SubscriberValidators.fee,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.smMd),

                  // ملاحظات
                  Expanded(
                    flex: 10,
                    child: CustomTextFormField(
                      title: AppStrings.addClientNoteLabel,
                      hintText: AppStrings.addClientNoteHintExample,
                      controller: _noteController,
                      fillColor: editFillColor,
                      borderColor: editBorderColor,
                      validator: SubscriberValidators.note,
                    ),
                  ),
                ],
              ),

              if (widget.isEditMode) ...[
                const SizedBox(height: AppSpacing.xxl),
                _DeleteButton(onTap: _onDelete),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalChip(FitnessGoal goal, String label) {
    return SelectableChip(
      label: label,
      isSelected: _selectedGoal == goal,
      onTap: () => setState(() => _selectedGoal = goal),
    );
  }

  Widget _programChip(ProgramType program, String label) {
    return SelectableChip(
      label: label,
      isSelected: _selectedProgram == program,
      onTap: () => setState(() => _selectedProgram = program),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.tinyBold.copyWith(
        color: context.appColors.textTertiary,
        letterSpacing: 1,
      ),
    );
  }
}

class _UnitLabel extends StatelessWidget {
  const _UnitLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
      child: UnconstrainedBox(
        child: Text(
          text,
          style: AppTextStyles.bodyS.copyWith(
            color: context.appColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.dateFormat,
    required this.isEditMode,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final DateFormat dateFormat;
  final bool isEditMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final hasValue = date != null;
    final highlighted = isEditMode && hasValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyS.copyWith(color: appColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mdLg),
            decoration: BoxDecoration(
              color:
                  highlighted
                      ? appColors.primarySoftBg
                      : Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color:
                    highlighted
                        ? Theme.of(context).colorScheme.primary
                        : appColors.border,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color:
                      highlighted
                          ? Theme.of(context).colorScheme.primary
                          : appColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.smMd),
                Text(
                  hasValue
                      ? dateFormat.format(date!)
                      : AppStrings.addClientDateHint,
                  style: AppTextStyles.bodyS.copyWith(
                    fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
                    color:
                        highlighted
                            ? Theme.of(context).colorScheme.primary
                            : appColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final danger = Theme.of(context).colorScheme.error;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.cardLg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.mdLg),
        decoration: BoxDecoration(
          color: appColors.dangerBg,
          borderRadius: BorderRadius.circular(AppRadius.cardLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, size: 16, color: danger),
            const SizedBox(width: AppSpacing.sm),
            Text(
              AppStrings.editClientDeleteClient,
              style: AppTextStyles.buttonM.copyWith(color: danger),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveChip extends StatelessWidget {
  const _SaveChip({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lgAlt),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Center(
          child:
              isLoading
                  ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                  : Text(
                    label,
                    style: AppTextStyles.buttonS.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
        ),
      ),
    );
  }
}
