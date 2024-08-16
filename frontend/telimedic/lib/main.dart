import 'package:flutter/material.dart';
import 'package:telemedic/pages/home.dart';
import 'package:telemedic/utils/constants.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Telemedic",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: themeData,
      home: const HomePage(),
    );
  }
}
