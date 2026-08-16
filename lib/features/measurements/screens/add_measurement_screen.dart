import 'package:glow_up/core/localization/app_locale.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_borders.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/media/photo_upload_box.dart';
import '../../subscribers/cubit/subscriber_cubit.dart';
import '../../subscribers/cubit/subscriber_state.dart';
import '../../subscribers/models/subscriber_model.dart';
import '../../subscribers/widgets/client_picker_field.dart';
import '../cubit/measurements_cubit.dart';
import '../cubit/measurements_state.dart';
import '../models/measurement.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key, this.subscriberId, this.subscriberName});

  final String? subscriberId;

  final String? subscriberName;

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  final _weightController = TextEditingController();
  final _waistController = TextEditingController();
  final _abdomenController = TextEditingController();
  final _picker = ImagePicker();

  File? _photoBefore;
  File? _photoAfter;
  SubscriberModel? _selectedSubscriber;

  late DateTime _measurementMonth = _firstOfMonth(DateTime.now());

  static DateTime _firstOfMonth(DateTime date) => DateTime(date.year, date.month);

  @override
  void initState() {
    super.initState();
    if (widget.subscriberId == null) {
      context.read<SubscriberCubit>().loadSubscribers();
    }
  }

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _measurementMonth,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      helpText: AppStrings.addMeasurementMonthLabel,
    );
    if (picked == null) return;
    setState(() => _measurementMonth = _firstOfMonth(picked));
  }

  Future<void> _pickPhoto({required bool isBefore}) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      if (isBefore) {
        _photoBefore = File(picked.path);
      } else {
        _photoAfter = File(picked.path);
      }
    });
  }

  void _save(BuildContext context) {
    final subscriberId = widget.subscriberId ?? _selectedSubscriber?.id;
    if (subscriberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.measurementsPickClientRequired)),
      );
      return;
    }

    final measurement = Measurement(
      subscriberId: subscriberId,
      measurementMonth: _measurementMonth,
      weight: double.tryParse(_weightController.text) ?? 0,
      waistSize: double.tryParse(_waistController.text) ?? 0,
      abdomenSize: double.tryParse(_abdomenController.text) ?? 0,
    );
    context.read<MeasurementsCubit>().saveMeasurement(
          measurement,
          photoBefore: _photoBefore,
          photoAfter: _photoAfter,
        );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _waistController.dispose();
    _abdomenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.addMeasurementScreenTitle)),
      body: BlocConsumer<MeasurementsCubit, MeasurementsState>(
        listener: (context, state) {
          if (state is MeasurementSaved) {
            final subscriberId = widget.subscriberId ?? _selectedSubscriber!.id;
            final subscriberName =
                widget.subscriberName ?? _selectedSubscriber!.fullName;
            context.pushReplacement(
              '/subscribers/$subscriberId/measurements?added=1',
              extra: subscriberName,
            );
          } else if (state is MeasurementsError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isSaving = state is MeasurementSaving;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.subscriberId == null) ...[
                  BlocBuilder<SubscriberCubit, SubscriberState>(
                    builder: (context, subscriberState) {
                      final subscribers = switch (subscriberState) {
                        SubscriberLoaded(:final subscribers) => subscribers,
                        SubscriberActionSuccess(:final subscribers) => subscribers,
                        SubscriberActionInProgress(:final subscribers) => subscribers,
                        _ => const <SubscriberModel>[],
                      };
                      return ClientPickerField(
                        subscribers: subscribers,
                        value: _selectedSubscriber,
                        onChanged: (subscriber) =>
                            setState(() => _selectedSubscriber = subscriber),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                InkWell(
                  onTap: _pickMonth,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: AppStrings.addMeasurementMonthLabel,
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      DateFormat.yMMMM(AppLocale.code).format(_measurementMonth),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: AppStrings.measurementsWeightLabel),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _waistController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: AppStrings.measurementsWaistLabel),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _abdomenController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: AppStrings.measurementsBellyLabel),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: PhotoUploadBox(
                        label: AppStrings.measurementsPhotoBefore,
                        imageFile: _photoBefore,
                        onTap: () => _pickPhoto(isBefore: true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PhotoUploadBox(
                        label: AppStrings.measurementsPhotoAfter,
                        imageFile: _photoAfter,
                        onTap: () => _pickPhoto(isBefore: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                ElevatedButton(
                  onPressed: isSaving ? null : () => _save(context),
                  child: isSaving
                      ? const SizedBox(
                          width: AppSizes.icon,
                          height: AppSizes.icon,
                          child: CircularProgressIndicator(
                            strokeWidth: AppBorders.regular,
                            color: AppColors.white,
                          ),
                        )
                      : Text(AppStrings.saveMeasurementCta),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
