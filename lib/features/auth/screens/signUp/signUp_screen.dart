import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/features/auth/cubit/auth_cubit.dart';
import 'package:glow_up/features/auth/screens/signup/widgets/signUp_form_car.dart';
import 'package:glow_up/features/auth/screens/signup/widgets/signUp_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().clearError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1️⃣ خلفية الجزء العلوي
          SignupHeader(),

          SignupFormCard(),
        ],
      ),
    );
  }
}
