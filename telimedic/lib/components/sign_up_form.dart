import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key, required GlobalKey<FormState> formKey,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController loginidController = TextEditingController();
  final TextEditingController useridController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController activeController = TextEditingController();

  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signIn(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        // show success
        check.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
        });
      } else {
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: loginidController,
              decoration: const InputDecoration(labelText: 'Login ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Login ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: useridController,
              decoration: const InputDecoration(labelText: 'User ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter User ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: pwdController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Age';
                }
                return null;
              },
            ),
            TextFormField(
              controller: sexController,
              decoration: const InputDecoration(labelText: 'Sex'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Sex';
                }
                return null;
              },
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Phone';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: designationController,
              decoration: const InputDecoration(labelText: 'Designation'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Designation';
                }
                return null;
              },
            ),
            TextFormField(
              controller: qualificationController,
              decoration: const InputDecoration(labelText: 'Qualification'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Qualification';
                }
                return null;
              },
            ),
            TextFormField(
              controller: userTypeController,
              decoration: const InputDecoration(labelText: 'User Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter User Type';
                }
                return null;
              },
            ),
            TextFormField(
              controller: activeController,
              decoration: const InputDecoration(labelText: 'Active'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Active status';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Process the form submission
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
        // if (isShowLoading)
        //   CustomPositioned(
        //     child: RiveAnimation.asset(
        //       "assets/RiveAssets/check.riv",
        //       onInit: (artboard) {
        //         StateMachineController controller =
        //         getRiveController(artboard);
        //         check = controller.findSMI("Check") as SMITrigger;
        //         error = controller.findSMI("Error") as SMITrigger;
        //         reset = controller.findSMI("Reset") as SMITrigger;
        //       },
        //     ),
        //   )
        // else
        //   const SizedBox(),
        // if (isShowConfetti)
        //   CustomPositioned(
        //     child: Transform.scale(
        //       scale: 2.0,
        //       child: RiveAnimation.asset(
        //         "assets/RiveAssets/confetti.riv",
        //         onInit: (artboard) {
        //           confetti = getRiveController(artboard).findSMI("Trigger explosion") as SMITrigger;
        //         },
        //       ),
        //     ),
        //   ),
    );
  }
}
