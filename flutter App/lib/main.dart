import 'package:flutter/material.dart';
import 'package:query_cortex/screens/chat_screen.dart';
import 'package:query_cortex/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isFirstTimeUser = prefs.getBool('isFirstTimeUser') ?? true;
  runApp(MyApp(isFirstTimeUser: isFirstTimeUser));
}

class MyApp extends StatelessWidget {
  final bool isFirstTimeUser;
  MyApp({required this.isFirstTimeUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OnboardingScreen(),
    );
  }
}

