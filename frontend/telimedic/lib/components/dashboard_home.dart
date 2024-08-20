// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:telemedic/widgets/header_widget.dart';
import 'package:telemedic/utils/responsive.dart';
import 'package:telemedic/models/user.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User user;
  const HomePage({super.key, required this.scaffoldKey, required this.user});

  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 15 : 18),
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 5 : 18,
              ),
              Header(scaffoldKey: scaffoldKey),
              _height(context),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'IBMPlexSans',
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Welcome ${convertRole(user.user_type)} !',
                      speed: const Duration(milliseconds: 100),
                      cursor: ' _',
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
              // const ActivityDetailsCard(),
              _height(context),
              // LineChartCard(),
              _height(context),
              // BarGraphCard(),
              _height(context),
            ],
          ),
        )));
  }

  String convertRole(String s) {
    if (s == "adm") {
      return "Administrator";
    } else if (s == "doc") {
      return "Doctor";
    } else {
      return "Patient";
    }
  }
}
