import 'package:flutter/material.dart';
import './pages/auth_page.dart';
import './pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import './pages/user_details_page.dart';
import 'firebase_options.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingPage(), // Use the loading page initially
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds, then navigate to AuthPage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthPage(), // Ensure AuthPage is not null
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Add this to center the column
          children: [
            Lottie.network(
              'https://lottie.host/5f9764d3-438a-44bb-be7c-a5d3d1643028/ovIOf07wSR.json',
              width: screenWidth,
              height: screenHeight * 0.8,
              fit: BoxFit.contain,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Loading',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      '...',
                      speed: const Duration(milliseconds: 800),
                      textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
