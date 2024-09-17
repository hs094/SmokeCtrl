import 'package:flutter/material.dart';

const primaryColorCode = 0xFFA9DFD8;

const cardBackgroundColor = Color(0xFF21222D);

var themeData = ThemeData(
    primaryColor: MaterialColor(
      primaryColorCode,
      <int, Color>{
        50: const Color(primaryColorCode).withOpacity(0.1),
        100: const Color(primaryColorCode).withOpacity(0.2),
        200: const Color(primaryColorCode).withOpacity(0.3),
        300: const Color(primaryColorCode).withOpacity(0.4),
        400: const Color(primaryColorCode).withOpacity(0.5),
        500: const Color(primaryColorCode).withOpacity(0.6),
        600: const Color(primaryColorCode).withOpacity(0.7),
        700: const Color(primaryColorCode).withOpacity(0.8),
        800: const Color(primaryColorCode).withOpacity(0.9),
        900: const Color(primaryColorCode).withOpacity(1.0),
      },
    ),
    // scaffoldBackgroundColor: const Color(0xFF171821),
    fontFamily: 'IBMPlexSans',
    brightness: Brightness.light);

String urlRegisterPerson = 'http://localhost:8080/addPerson';

final List<String> qualifications = [
  "MBBS",
  "Postgraduate",
  "MD",
  "Fellowship",
  "Apprenticeship",
  "Specialization",
];
