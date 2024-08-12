import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:telemedic/components/sign_in_form.dart';
import 'package:telemedic/components/sign_up_form.dart';

Future<Object?> customSigninDialog(BuildContext context, {required ValueChanged onClosed}) {
  final Box boxLogin = Hive.box("login");
  final GlobalKey<FormState> formKey = GlobalKey();

  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Sign up",
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 620,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false, // avoid overflow error when keyboard shows up
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                  ),
                  SignInForm(formKey: formKey),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.black12),
                        ),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Don't have an account yet?",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          formKey.currentState?.reset();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pop(context); // Close the sign-in dialog
                            customSignUpDialog(context, onClosed: onClosed); // Open the sign-up dialog
                          });
                        },
                        child: const Text("Sign Up now"),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}

Future<Object?> customSignUpDialog(BuildContext context, {required ValueChanged onClosed}) {
  final Box boxLogin = Hive.box("login");
  final GlobalKey<FormState> formKey = GlobalKey();
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Sign up",
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 620,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false, // avoid overflow error when keyboard shows up
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                  ),
                  SignUpForm(formKey: formKey),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.black12),
                        ),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          formKey.currentState?.reset();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Navigator.pop(context); // Close the sign-up dialog
                            customSigninDialog(context, onClosed: onClosed); // Open the sign-in dialog
                          });
                        },
                        child: const Text("Sign In"),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}

// class SignupForm extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//
//   const SignupForm({required this.formKey});
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Login-ID'),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your Login ID';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Password'),
//             obscureText: true,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your password';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Age'),
//             obscureText: true,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your Age';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Age'),
//             obscureText: true,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your Age';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               if (formKey.currentState!.validate()) {
//                 // Process the sign-up
//               }
//             },
//             child: const Text('Sign Up'),
//           ),
//         ],
//       ),
//     );
//   }
// }
