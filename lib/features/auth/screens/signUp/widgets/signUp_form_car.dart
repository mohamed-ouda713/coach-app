import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/core/constants/app_radius.dart';
import 'package:glow_up/core/constants/app_spacing.dart';
import 'package:glow_up/core/constants/app_strings.dart';
import 'package:glow_up/core/widgets/status/app_success_snackbar.dart';
import 'package:glow_up/features/auth/cubit/auth_cubit.dart';
import 'package:glow_up/features/auth/cubit/auth_state.dart';
import 'package:glow_up/features/auth/screens/signup/widgets/signup_fields.dart';
import 'package:glow_up/features/auth/screens/signup/widgets/signUp_footer.dart';
import 'package:glow_up/features/auth/screens/signup/widgets/signUp_form_heading.dart';
import 'package:glow_up/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class SignupFormCard extends StatefulWidget {
  const SignupFormCard({super.key});

  @override
  State<SignupFormCard> createState() => _SignupFormCardState();
}

class _SignupFormCardState extends State<SignupFormCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUp(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.32,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.sheet),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.xxl,
                ),
                child: Form(
                  key: _formKey,
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        AppSuccessSnackbar.show(
                          context,
                          AppStrings.signUpSuccessMessage,
                        );
                        context.go(AppRoutes.home);
                      } else if (state is AuthSignUpEmailConfirmationRequired) {
                        AppSuccessSnackbar.show(
                          context,
                          AppStrings.signUpConfirmEmailMessage,
                        );
                        context.go(AppRoutes.login);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      final errorMessage =
                          state is AuthError ? state.message : null;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SignupFormHeading(),

                          SignupFields(
                            nameController: _nameController,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            enabled: !isLoading,
                            errorMessage: errorMessage,
                          ),

                          SignupFooter(
                            isLoading: isLoading,
                            onSignUpPressed: () {
                              _onSignUp(context);
                            },
                            onPressed: () {
                              context.go(AppRoutes.login);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
