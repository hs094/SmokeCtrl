import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:telmed/widgets/header_widget.dart';
import 'package:telmed/utils/responsive.dart';
import 'package:telmed/models/user.dart';

class DashHomePage extends StatelessWidget {
  static const routeName = '/dash-home';
  final GlobalKey<ScaffoldState> scaffoldKey;
  final User user;
  const DashHomePage({super.key, required this.scaffoldKey, required this.user});

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 15 : 18),
              child: Column(children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 5 : 18,
                ),
                Header(scaffoldKey: scaffoldKey),
                height(context),
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
                height(context),
                Card(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFF69170),
                            Color(0xFF7D96E6),
                          ]),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Colors
                                  .transparent, // Optional: Background color if needed
                            ),
                            child: SvgPicture.asset(
                              "assets/icon/icon_chat.svg",
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 16.0, left: 16.0),
                              child: (Text("Hi! You Can Ask Me",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: (Text("Anything",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 16.0, bottom: 16.0),
                              child: (TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/chat');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white),
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.black),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                                    child: GradientText(
                                      "Ask Now",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      gradient: LinearGradient(colors: [
                                        Color(0xFFF69170),
                                        Color(0xFF7D96E6),
                                      ]),
                                    ),
                                  ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0),
                  child: Text(
                    "Recent Chats",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                // LineChartCard(),
                height(context),
              ]),
            )));
  }

  String convertRole(String s) {
    if (s == "adm") {
      return "Administrator";
    } else if (s == "doc") {
      return "Dr. ${user.name}";
    } else {
      return "Patient ${user.name}";
    }
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}
