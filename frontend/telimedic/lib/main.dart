import 'package:flutter/material.dart';
import 'package:telemedic/pages/home.dart';
import 'package:telemedic/components/export_components.dart';
import 'package:telemedic/utils/constants.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  get scaffoldKey => null;

  get user => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Telemedic",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: themeData,
      // home: const HomePage(),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ChatPage.routeName: (context) => const ChatPage(),
        DashHomePage.routeName: (context) => DashHomePage(scaffoldKey: scaffoldKey, user: user)
      },
    );
  }
}
