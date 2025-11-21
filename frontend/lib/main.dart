import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const PharmacyApp());
}

class PharmacyApp extends StatelessWidget {
  const PharmacyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ЕкоАптека',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        useMaterial3: true,
      ),
      home: const MainScreen(), // <--- Змінилось
    );
  }
}