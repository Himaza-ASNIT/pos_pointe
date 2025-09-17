// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:pos_pointe/pages/signin.dart';
// import 'package:pos_pointe/widgets/mybutton.dart';
// import 'package:pos_pointe/widgets/textfield.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final localAuth = LocalAuthentication();
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   bool isloading = false;

//   // signup with email password
//   Future<void> signUpWithEmailPasssword() async {
//     String email = emailController.text;
//     String password = passwordController.text;
//     String confirmPassword = confirmPasswordController.text;

//     if (password != confirmPassword) {
//       showErrorMessage("Password don't match");
//       return;
//     }
//     setState(() {
//       isloading = true;
//     });
//     try {
//       await auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       SharedPreferences preferences = await SharedPreferences.getInstance();

//       bool? enableBiometric = await showBiometricDialog();

//       if (enableBiometric == true) {
//         preferences.setBool("Biometric enabled", true);
//       }
//       showSuccessMessage('Account created successfully!');
//       Navigator.pop(context);
//     } catch (e) {
//       showErrorMessage('Failed to sign up. Try again!');
//     } finally {
//       setState(() {
//         isloading = false;
//       });
//     }
//   }

//   //pop up to enable biometric login
//   Future<bool?> showBiometricDialog() async {
//     return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Enable Biometric Login?'),
//           content: Text(
//               'Would you like to enable fingerprint login for the next time?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: Text('Yes'),
//             )
//           ],
//         );
//       },
//     );
//   }

//   //method for show error messaage
//   void showErrorMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   // Method to show success message
//   void showSuccessMessage(String messaage) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(messaage),
//       backgroundColor: Colors.green,
//     ));
//   }

//   @override
//   void dispose() {
//     // Dispose of controllers to release resources
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Center(
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                 // Logo
//                 Image.asset(
//                   'assets/pos_point_bgr.png', // Path to your image
//                   width: 200,
//                   height: 200,
//                 ),

//                 // Welcome back text
//                 Text(
//                   "Sign Up to POS Pointe",
//                   style: TextStyle(
//                       color: Colors.grey[900],
//                       fontSize: 30,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 25),

//                 // email text field
//                 MyTextField(
//                   controller: emailController,
//                   hintText: "Email",
//                   obscureText: false,
//                 ),
//                 const SizedBox(height: 10),

//                 // Password text field
//                 MyTextField(
//                   controller: passwordController,
//                   hintText: "Password",
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 10),
// //confirm password text field
//                 MyTextField(
//                   controller: confirmPasswordController,
//                   hintText: "Confirm Password",
//                   obscureText: true,
//                 ),

//                 const SizedBox(height: 25),

//                 //sign in button
//                 Mybutton(
//                   onTap: signUpWithEmailPasssword,
//                   text: 'Sign up',
//                 ),
//                 const SizedBox(height: 25),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Divider(
//                           thickness: 0.5,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       // Padding(
//                       //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       //   child: Text(
//                       //     "Or continue with",
//                       //     style: TextStyle(
//                       //       color: Colors.grey[700],
//                       //     ),
//                       //   ),
//                       // ),
//                       // Expanded(
//                       //   child: Divider(
//                       //     color: Colors.grey[400],
//                       //     thickness: 0.5,
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // const Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: [
//                 //     SquareTile(imagePath: 'assets/google.png'),
//                 //   ],
//                 // ),
//                 // const SizedBox(height: 10),

//                 //signup here!
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already have an account?",
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SigninPage()),
//                         );
//                       },
//                       child: Text(
//                         "Sign in",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ])),
//         ),
//       ),
//     );
//   }
// }


// It sounds like your Flutter app is facing an issue when running on a physical iPhone after the first launch. This behavior, where the app flashes and doesn't open, can be caused by a number of potential issues. Here's a list of common problems and steps you can take to troubleshoot:

// ### 1. **App Crashes After Launch**
//    - **Cause**: The app might be crashing immediately after launch due to a runtime error.
//    - **Solution**: Check the crash logs to understand what might be going wrong. You can do this using Xcode's console or the `flutter run` command in your terminal with the device connected.
   
//    **Steps**:
//    - Open Xcode, select your device, and run the app.
//    - Look at the output logs for errors.
//    - Alternatively, use the command `flutter run --verbose` to get detailed logs.

// ### 2. **Unfinished App Installation**
//    - **Cause**: The app might not be fully installed or built correctly on your physical device.
//    - **Solution**: Try uninstalling the app from your device and reinstalling it.
   
//    **Steps**:
//    - Go to your iPhone's home screen, press and hold the app icon, and select "Delete App."
//    - Then, reconnect the device, and try running the app again using `flutter run`.

// ### 3. **App Permissions**
//    - **Cause**: The app may be requiring permissions that have not been granted or are not properly set up.
//    - **Solution**: Ensure that all necessary permissions are properly configured in your app’s `Info.plist` file.
   
//    **Steps**:
//    - Open your `ios/Runner/Info.plist` file.
//    - Ensure that any permissions like camera, location, etc., are included if your app needs them. For example:
//      ```xml
//      <key>NSCameraUsageDescription</key>
//      <string>We need access to your camera</string>
//      ```

// ### 4. **Debug Mode vs. Release Mode**
//    - **Cause**: Flutter runs your app in "debug" mode when using an emulator, but the app may have issues when running in release mode on a physical device.
//    - **Solution**: Try running your app in release mode to see if the issue persists.
   
//    **Steps**:
//    - Run the app in release mode by using `flutter run --release`.

// ### 5. **Outdated Flutter or Xcode Versions**
//    - **Cause**: An outdated version of Flutter or Xcode might be causing issues when deploying to a physical device.
//    - **Solution**: Ensure that both Flutter and Xcode are up to date.
   
//    **Steps**:
//    - Update Flutter using `flutter upgrade`.
//    - Check for any Xcode updates through the Mac App Store or via the Xcode command line tools.

// ### 6. **App Not Signed Correctly**
//    - **Cause**: If the app isn't signed properly, it could cause the issue where it opens briefly and then closes.
//    - **Solution**: Check the app's signing configuration in Xcode.
   
//    **Steps**:
//    - Open your project in Xcode (`ios/Runner.xcworkspace`).
//    - Go to the "Signing & Capabilities" tab and ensure you’ve selected the correct team and provisioning profile.
//    - Rebuild and deploy the app.

// ### 7. **Device-Specific Issues**
//    - **Cause**: There could be something specific to your physical device causing the issue.
//    - **Solution**: Try running the app on another iOS device, or reboot your device and attempt again.

//    **Steps**:
//    - Restart your iPhone and try again.
//    - If possible, test the app on another iOS device to see if the issue is specific to your phone.

// ### 8. **App Incompatibility with iOS Version**
//    - **Cause**: If your app targets a different version of iOS than what your physical device is running, compatibility issues might arise.
//    - **Solution**: Ensure your app supports the iOS version on your physical device.

//    **Steps**:
//    - Check your `ios/Podfile` for the iOS deployment target. Make sure it aligns with the iOS version on your device.

// ### 9. **Flutter Hot Reload/Hot Restart Issues**
//    - **Cause**: Sometimes, hot reload or hot restart doesn’t clean up correctly, which can leave your app in an unstable state.
//    - **Solution**: Perform a full app restart.
   
//    **Steps**:
//    - Stop the app in your IDE (or Xcode) and run it again.
//    - You can also restart the device and try launching the app from scratch.

// ### 10. **Check for Flutter Doctor Warnings**
//    - **Cause**: There might be issues with the Flutter setup that are not immediately obvious.
//    - **Solution**: Run `flutter doctor` to see if there are any warnings or errors related to your environment.
   
//    **Steps**:
//    - Run `flutter doctor` and ensure there are no unresolved issues.

// By following these steps, you should be able to identify and fix the issue preventing your app from opening on your physical device. If you get specific error messages from the logs, feel free to share them, and I can help you debug further.


// when i install my flutter app in an ios emulator its worked smoothly . but  i tried it with an physical device (iphone). its worked for the 1st time . when i tried to click the app icon and try to open , its just flashing and not open 

// why is that.