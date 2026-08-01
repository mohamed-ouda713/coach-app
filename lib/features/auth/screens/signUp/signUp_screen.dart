import 'package:flutter/material.dart';
import 'package:glow_up/features/auth/screens/signUp/widgets/signUp_form_car.dart';
import 'package:glow_up/features/auth/screens/signUp/widgets/signUp_header.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
