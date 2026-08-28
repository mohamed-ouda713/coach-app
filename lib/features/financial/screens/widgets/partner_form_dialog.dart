// lib/features/financial/screens/widgets/partner_form_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/widgets/Buttons/Primary_Buttons/primary_Buttons.dart';
import 'package:glow_up/core/widgets/Buttons/Text_Buttons/Text_Form_Input.dart';
import 'package:glow_up/core/widgets/error_widgets/app_error_snackbar.dart';
import 'package:glow_up/core/widgets/status/app_success_snackbar.dart';

import '../../cubit/financial_cubit.dart';
import '../../cubit/financial_state.dart';
import '../../helper/financial_validators.dart';
import '../../models/partner_model.dart';

class PartnerFormDialog extends StatefulWidget {
  const PartnerFormDialog({super.key, this.initialPartner});

  final PartnerModel? initialPartner;

  bool get isEditMode => initialPartner != null;

  static Future<void> show(BuildContext context, {PartnerModel? partner}) {
    return showDialog<void>(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<FinancialCubit>(),
            child: PartnerFormDialog(initialPartner: partner),
          ),
    );
  }

  @override
  State<PartnerFormDialog> createState() => _PartnerFormDialogState();
}

class _PartnerFormDialogState extends State<PartnerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _shareController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.initialPartner;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _shareController = TextEditingController(
      text: existing?.sharePercentage.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shareController.dispose();
    super.dispose();
  }

  /// مجموع نسب باقي الشركاء (بدون الشريك الحالي لو الديالوج بوضع
  /// تعديل) — بنستخدمه كسقف عشان الشريك الحالي/الجديد ما يخلي
  /// المجموع الكلي يتخطى 100%.
  double get _othersTotal {
    final state = context.read<FinancialCubit>().state;
    if (state is! FinancialLoaded) return 0;
    return state.partners
        .where((p) => p.id != widget.initialPartner?.id)
        .fold<double>(0, (sum, p) => sum + p.sharePercentage);
  }

  Future<void> _onSave() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isSubmitting = true);

    final cubit = context.read<FinancialCubit>();
    final name = _nameController.text.trim();
    final share = double.parse(_shareController.text.trim());

    final errorMessage =
        widget.isEditMode
            ? await cubit.updatePartner(
              id: widget.initialPartner!.id,
              name: name,
              sharePercentage: share,
            )
            : await cubit.addPartner(name: name, sharePercentage: share);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (errorMessage != null) {
      AppErrorSnackbar.show(context, errorMessage);
      return;
    }

    Navigator.of(context).pop();
    AppSuccessSnackbar.show(context, AppStrings.financePartnerSavedMessage);
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
                widget.isEditMode
                    ? AppStrings.financeEditPartnerTitle
                    : AppStrings.financeAddPartnerTitle,
                style: AppTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextFormField(
                title: AppStrings.financePartnerNameLabel,
                hintText: AppStrings.financePartnerNameLabel,
                controller: _nameController,
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                validator: FinancialValidators.partnerName,
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextFormField(
                title: AppStrings.financeSharePercentageLabel,
                hintText: '0',
                controller: _shareController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator:
                    (value) => FinancialValidators.sharePercentage(
                      value,
                      othersTotal: _othersTotal,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                title:
                    widget.isEditMode
                        ? AppStrings.editClientSaveChangesCta
                        : AppStrings.financeAddNewPartner,
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
