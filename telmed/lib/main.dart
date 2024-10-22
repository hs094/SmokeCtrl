import 'package:flutter/material.dart';
import 'package:telmed/pages/home.dart';
import 'package:telmed/components/export_components.dart';
import 'package:telmed/utils/constants.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  get scaffoldKey => null;
  get user => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "iMediXCare",
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: themeData,
      // home: const HomePage(),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        DashHomePage.routeName: (context) => DashHomePage(scaffoldKey: scaffoldKey, user: user)
      },
    );
  }
}
