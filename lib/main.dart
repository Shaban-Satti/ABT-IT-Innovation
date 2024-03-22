// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qr_scanner/splash_screen.dart';





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const customSwatch = MaterialColor(
    0xFFFF5252,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFFF5252),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'QR Scanner',
        theme: ThemeData(
          primarySwatch: customSwatch,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen()


    );
  }
}


