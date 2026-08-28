import 'package:flutter/material.dart';
import '../theme/app_colors_extension.dart';

/// Shortcut: `context.appColors.warning` instead of
/// `Theme.of(context).extension<AppColorsExtension>()!.warning`.
extension AppColorsContextX on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
