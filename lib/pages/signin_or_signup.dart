import 'package:flutter/material.dart';
import 'package:pos_pointe/pages/signin.dart';
import 'package:pos_pointe/pages/signup.dart';

class SigninOrSignup extends StatefulWidget {
  const SigninOrSignup({super.key});

  @override
  State<SigninOrSignup> createState() => _SigninOrSignupState();
}

class _SigninOrSignupState extends State<SigninOrSignup> {
  bool showSigninPage = true;

  void togglePage() {
    setState(() {
      showSigninPage = !showSigninPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSigninPage) {
      return SigninPage(
        onTap: togglePage,
      );
    } else {
      return SignupPage(
        onTap: togglePage,
      );
    }
  }
}
