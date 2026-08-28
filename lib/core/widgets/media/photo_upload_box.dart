import 'dart:io';

import 'package:flutter/material.dart';
import '../../constants/app_borders.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/context_extensions.dart';

/// مربع رفع صورة (قبل/بعد) — أيقونة رفع لو فاضي، أو الصورة المحددة.
class PhotoUploadBox extends StatelessWidget {
  const PhotoUploadBox({
    super.key,
    required this.label,
    required this.onTap,
    this.imageFile,
  });

  final String label;
  final VoidCallback onTap;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: appColors.bgSubtle,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: appColors.border,
              width: AppBorders.regular,
            ),
            image:
                imageFile != null
                    ? DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    )
                    : null,
          ),
          alignment: Alignment.center,
          child:
              imageFile == null
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: appColors.textSecondary,
                        size: AppSizes.icon,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        label,
                        style: AppTextStyles.caption.copyWith(
                          color: appColors.textSecondary,
                        ),
                      ),
                    ],
                  )
                  : null,
        ),
      ),
    );
  }
}
