import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pos_pointe/firebase_options.dart';
import 'package:pos_pointe/pages/signin.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initNotification();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Message received: ${message.notification?.title}");
  });

  runApp(MyApp());
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> initNotification() async {
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  String? token = await messaging.getToken();
  print("FCM Token: $token");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(
          './assets/pos_pointe.png',
          width: 1000,
          height: 1000,
        ),
        splashIconSize: double.infinity,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        duration: 1000,
        nextScreen: const SigninPage(),
      ),
    );
  }
}
