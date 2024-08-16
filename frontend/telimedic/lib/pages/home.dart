import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:telemedic/pages/login.dart';
import 'package:telemedic/pages/signup.dart';
import 'dart:ui';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignInDialogShown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              bottom: 200,
              left: 100,
              child: Image.asset('assets/Backgrounds/Spline.png')),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          )),
          const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            child: const SizedBox(),
          )),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            top: isSignInDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const SizedBox(
                        width: 440,
                        child: Column(children: [
                          Text(
                            "AI-Powered Guidance for a Healthier, Tobacco-Free Life",
                            style: TextStyle(
                                fontSize: 44,
                                fontFamily: "Poppins",
                                height: 1.2),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                              "Revolutionize your journey to quitting tobacco with our AI-driven chatbot, offering personalized support and guidance for a healthier, smoke-free, and addiction-free life.")
                        ]),
                      ),
                      const Spacer(
                        flex: 4,
                      ),
                      Column(
                          children: <Widget>[
                            FadeInUp(duration: const Duration(milliseconds: 1500), child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const LoginPage()));
                              },
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.black
                                  ),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: const Text("Login", style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              ),),
                            )),
                            const SizedBox(height: 20,),
                            FadeInUp(duration: const Duration(milliseconds: 1500), child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const SignupPage()));
                              },
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.black
                                  ),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: const Text("Sign Up", style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              ),),
                            )),
                            // FadeInUp(duration: const Duration(milliseconds: 1600), child: Container(
                            //   padding: const EdgeInsets.only(top: 3, left: 3),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(50),
                            //       border: const Border(
                            //         bottom: BorderSide(color: Colors.black),
                            //         top: BorderSide(color: Colors.black),
                            //         left: BorderSide(color: Colors.black),
                            //         right: BorderSide(color: Colors.black),
                            //       )
                            //   ),
                            //   child: MaterialButton(
                            //     minWidth: double.infinity,
                            //     height: 60,
                            //     onPressed: () {
                            //       Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                            //     },
                            //     color: Colors.black,
                            //     elevation: 0,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(50)
                            //     ),
                            //     child: const Text("Sign up", style: TextStyle(
                            //         fontWeight: FontWeight.w600,
                            //         fontSize: 18
                            //     ),),
                            //   ),
                            // )),
                          ]),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          "Embark on a transformative journey to quit tobacco with our AI-powered chatbot, providing tailored support and guidance for a healthier, smoke-free future. Proudly developed at IIT Kharagpur.",
                          style: TextStyle(),
                        ),
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
