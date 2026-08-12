import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_sizes.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/models/user_model.dart';
import 'package:glow_up/core/theme/app_text_styles.dart';
import 'package:glow_up/core/theme/context_extensions.dart';
import 'package:glow_up/core/theme/cubit/theme_cubit.dart';
import 'package:glow_up/core/widgets/selection/selectable_chip.dart';
import 'package:glow_up/features/auth/cubit/auth_cubit.dart';
import 'package:glow_up/features/auth/cubit/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text(AppStrings.logoutCta),
            content: const Text(AppStrings.logoutConfirmMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text(AppStrings.dialogCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  AppStrings.logoutCta,
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileTitle)),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final rawUser = state is AuthAuthenticated ? state.user : null;
          final userModel = rawUser != null ? UserModel.fromSupabaseUser(rawUser) : null;

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileInfoTile(
                  icon: Icons.person_outline,
                  label: AppStrings.profileFullNameLabel,
                  value: userModel?.displayName ?? '-',
                ),
                const SizedBox(height: AppSpacing.lg),
                _ProfileInfoTile(
                  icon: Icons.email_outlined,
                  label: AppStrings.profileEmailLabel,
                  value: userModel?.displayEmail ?? '-',
                ),
                const SizedBox(height: AppSpacing.lg),
                const _ThemeModeSelector(),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  label: Text(
                    AppStrings.logoutCta,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final currentMode = context.watch<ThemeCubit>().state;
    final isSystemDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final isDarkSelected =
        currentMode == ThemeMode.dark ||
        (currentMode == ThemeMode.system && isSystemDark);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: context.appColors.bgSubtle,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.profileAppearanceLabel,
              style: AppTextStyles.bodyL.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          SelectableChip(
            label: AppStrings.themeLight,
            isSelected: !isDarkSelected,
            onTap: () => context.read<ThemeCubit>().setThemeMode(ThemeMode.light),
          ),
          const SizedBox(width: AppSpacing.sm),
          SelectableChip(
            label: AppStrings.themeDark,
            isSelected: isDarkSelected,
            onTap: () => context.read<ThemeCubit>().setThemeMode(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: context.appColors.bgSubtle,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSizes.icon,
            color: context.appColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyS.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs / 2),
                Text(
                  value,
                  style: AppTextStyles.bodyL.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
