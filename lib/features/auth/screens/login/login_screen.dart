import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glow_up/features/auth/cubit/auth_cubit.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_form_card.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().clearError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [LoginHeader(), LoginFormCard()]));
  }
}
