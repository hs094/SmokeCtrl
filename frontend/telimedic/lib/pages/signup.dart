import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:telemedic/pages/home.dart';
import 'package:telemedic/utils/constants.dart';
import 'package:telemedic/services/register.dart';
import 'package:flutter/foundation.dart';
import 'package:telemedic/pages/login.dart';
import 'package:telemedic/models/user.dart';
import 'package:telemedic/utils/helper_func.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Male');
  TextEditingController loginIdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int _age = 18;
  bool activeController = false;
  TextEditingController userController = TextEditingController(text: 'pat');
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  TextEditingController desgnController = TextEditingController();
  String? qualController;
  RegisterUser service = RegisterUser();
  HelperFunc helper = HelperFunc();

  @override
  void initState() {
    super.initState();
    qualController = qualifications.first;
  }

  bool _passwordsMatch() {
    return pwdController.text == confirmPwdController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Email',
                                        hintText: 'Enter your Email Address',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Add space between the two fields
                            Expanded(
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1300),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Name',
                                        hintText: 'Enter First and Last Name',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1400),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: loginIdController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Login-ID',
                                        hintText: 'Enter your Login-ID',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 10), // Add space between the two fields
                            Expanded(
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1400),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Phone',
                                        hintText: 'Enter your Phone Number',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Gender",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Radio<String>(
                                    value: 'Male',
                                    groupValue: genderController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        genderController.text =
                                            value!; // Update the controller
                                      });
                                    },
                                  ),
                                  const Text("Male"),
                                  const SizedBox(width: 15),
                                  Radio<String>(
                                    value: 'Female',
                                    groupValue: genderController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        genderController.text =
                                            value!; // Update the controller
                                      });
                                    },
                                  ),
                                  const Text("Female"),
                                  const SizedBox(width: 15),
                                  Radio<String>(
                                    value: 'Others',
                                    groupValue: genderController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        genderController.text =
                                            value!; // Update the controller
                                      });
                                    },
                                  ),
                                  const Text("Others"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1500),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Age",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (_age > 0) _age--;
                                            });
                                          },
                                        ),
                                        Text(_age.toString()),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              if (_age < 120) _age++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Are you a Active User?",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    CheckboxListTile(
                                      title: const Text("Active"),
                                      value: activeController,
                                      onChanged: (newValue) {
                                        setState(() {
                                          activeController = newValue!;
                                        });
                                      },
                                      controlAffinity: ListTileControlAffinity
                                          .leading, // leading Checkbox
                                    ),
                                    // const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1700),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "User Type",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Radio<String>(
                                    value: 'pat',
                                    groupValue: userController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        userController.text = value!;
                                      });
                                    },
                                  ),
                                  const Text("Patient"),
                                  const SizedBox(width: 12),
                                  Radio<String>(
                                    value: 'doc',
                                    groupValue: userController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        userController.text = value!;
                                      });
                                    },
                                  ),
                                  const Text("Doctor"),
                                  const SizedBox(width: 12),
                                  Radio<String>(
                                    value: 'adm',
                                    groupValue: userController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        userController.text = value!;
                                      });
                                    },
                                  ),
                                  const Text("Admin"),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              if (userController.text != 'pat') ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: TextFormField(
                                          controller: desgnController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Designation',
                                            hintText: 'Enter your Designation',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: DropdownButtonFormField<String>(
                                          value: qualController,
                                          isExpanded:
                                              true, // Ensure the dropdown is fully expanded
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Education',
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              qualController = newValue;
                                            });
                                          },
                                          items: qualifications
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              // const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              TextFormField(
                                controller:
                                    pwdController, // Assign the controller here
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1900),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Confirm Password",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              TextFormField(
                                controller:
                                    confirmPwdController, // Assign the controller here
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != pwdController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // Optionally check passwords as the user types
                                  setState(() {
                                    // This triggers a rebuild if you want to show a message or update UI based on match
                                    _passwordsMatch();
                                  });
                                },
                              ),
                              // const SizedBox(height: 10),
                              // Optionally display a message if passwords don't match
                              if (!_passwordsMatch())
                                const Text(
                                  "Passwords do not match",
                                  style: TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeInUp(
              duration: const Duration(milliseconds: 2000),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        if (kDebugMode) {
                          User user = User(
                              "",
                              loginIdController.text,
                              pwdController.text,
                              nameController.text,
                              _age,
                              genderController.text,
                              phoneController.text,
                              emailController.text,
                              desgnController.text,
                              qualController!,
                              userController.text,
                              activeController);
                          List<String> response = (await service.saveUser(user));
                          print(response[0]);
                          print(response[1]);
                          print(response[2]);
                          // Use the helper function to show the alert dialog
                          helper.showAlertDialog(
                            context,
                            response[1], // Title
                            response[2], // Content
                          );
                        }
                      },
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "  Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
