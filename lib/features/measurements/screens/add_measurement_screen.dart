import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/media/photo_upload_box.dart';
import '../cubit/measurements_cubit.dart';
import '../cubit/measurements_state.dart';
import '../models/measurement.dart';

/// شاشة إضافة قياس شهري جديد لعميلة (F8).
class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key, required this.subscriberId});

  final String subscriberId;

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
    final measurement = Measurement(
      subscriberId: widget.subscriberId,
      measurementMonth: DateTime.now(),
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
      appBar: AppBar(title: const Text(AppStrings.addMeasurementScreenTitle)),
      body: BlocConsumer<MeasurementsCubit, MeasurementsState>(
        listener: (context, state) {
          if (state is MeasurementSaved) {
            Navigator.of(context).pop();
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
                TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: AppStrings.measurementsWeightLabel),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _waistController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: AppStrings.measurementsWaistLabel),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _abdomenController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: AppStrings.measurementsBellyLabel),
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
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(AppStrings.saveMeasurementCta),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
