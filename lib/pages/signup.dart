import 'package:flutter/material.dart';
import 'package:pos_pointe/widgets/mybutton.dart';
import 'package:pos_pointe/widgets/textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Sign user up method
  void signUserUp() {
    // Your sign-up logic here
  }

  @override
  void dispose() {
    // Dispose controllers to release resources
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/pos_point_bgr.png', // Path to your logo
                  width: 200,
                  height: 200,
                ),

                // Title
                Text(
                  "Create an Account",
                  style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 25),

                // Username text field
                MyTextField(
                  controller: usernameController,
                  hintText: "Full Name",
                  obscureText: false,
                ),
                const SizedBox(height: 25),

                // Email text field
                MyTextField(
                  controller: emailController,
                  hintText: "Email Address",
                  obscureText: false,
                ),
                const SizedBox(height: 25),

                // Password text field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 25),

                // Confirm Password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // Sign Up button
                Mybutton(
                  onTap: signUserUp,
                ),

                const SizedBox(height: 20),

                // Login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Sign In page
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Sign In here",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
