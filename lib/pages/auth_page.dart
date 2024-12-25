// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_pointe/pages/home_page.dart';
// import 'package:pos_pointe/pages/signin.dart'; // Import the sign-in page
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:local_auth/local_auth.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   bool _isFirstTime = true;
//   final LocalAuthentication _auth = LocalAuthentication();

//   @override
//   void initState() {
//     super.initState();
//     _checkFirstLogin();
//   }

//   // Check if user has logged in before
//   Future<void> _checkFirstLogin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasLoggedInBefore = prefs.getBool('hasLoggedInBefore') ?? false;

//     if (hasLoggedInBefore) {
//       // Show authentication popup for returning users
//       _showBiometricPopup();
//     } else {
//       // Mark first login after successful sign-in
//       prefs.setBool('hasLoggedInBefore', true);
//     }
//   }

//   // Biometric or PIN popup
//   Future<void> _showBiometricPopup() async {
//     bool isAuthenticated = false;

//     try {
//       isAuthenticated = await _auth.authenticate(
//         localizedReason: 'Authenticate to access POS Pointe',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//     } catch (e) {
//       print('Error during authentication: $e');
//     }

//     if (!isAuthenticated) {
//       // If authentication fails, log the user out
//       FirebaseAuth.instance.signOut();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return HomePage(); // If the user is logged in, show the home page
//           } else {
//             // Always show the sign-in page if the user is not logged in
//             return SigninPage(); // Always show Sign-in page when not logged in
//           }
//         },
//       ),
//     );
//   }
// }
