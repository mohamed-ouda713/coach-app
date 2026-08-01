import 'package:flutter/material.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_form_card.dart';
import 'package:glow_up/features/auth/screens/login/widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [LoginHeader(), LoginFormCard()]));
  }
}
