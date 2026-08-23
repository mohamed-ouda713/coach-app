// lib/features/financial/screens/widgets/add_expense_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/primary_Buttons.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_snackbar.dart';
import 'package:glow_up/core/widgets/inputs/app_date_field.dart';
import 'package:glow_up/core/widgets/status/app_success_snackbar.dart';

import '../../cubit/financial_cubit.dart';
import '../../helper/financial_validators.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<FinancialCubit>(),
            child: const AddExpenseDialog(),
          ),
    );
  }

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _date = DateTime.now();
  bool _isSubmitting = false;

  static final _dateFormat = DateFormat('dd / MM / yyyy');

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _date = picked);
  }

  Future<void> _onSave() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_date == null) {
      AppErrorSnackbar.show(context, AppStrings.financeDateRequired);
      return;
    }

    setState(() => _isSubmitting = true);

    final errorMessage = await context.read<FinancialCubit>().addExpense(
      description: _descriptionController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      date: _date!,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (errorMessage != null) {
      AppErrorSnackbar.show(context, errorMessage);
      return;
    }

    Navigator.of(context).pop();
    AppSuccessSnackbar.show(context, AppStrings.financeExpenseAddedMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.cardLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.financeAddExpenseTitle,
                style: AppTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextFormField(
                title: AppStrings.financeExpenseDescriptionLabel,
                hintText: AppStrings.financeExpenseDescriptionHint,
                controller: _descriptionController,
                inputFormatters: [LengthLimitingTextInputFormatter(60)],
                validator: FinancialValidators.expenseDescription,
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextFormField(
                title: AppStrings.addClientAmountLabel,
                hintText: '0.00',
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  LengthLimitingTextInputFormatter(7),
                ],
                validator: FinancialValidators.amount,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppDateField(
                label: AppStrings.financeDateLabel,
                date: _date,
                dateFormat: _dateFormat,
                onTap: _pickDate,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                title: AppStrings.financeAddExpenseCta,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onPrimary,
                isLoading: _isSubmitting,
                onTap: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
