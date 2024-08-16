import 'dart:async';
import 'dart:convert';
import 'package:telemedic/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RegisterUser {
  Future<http.Response> saveUser(User user) async {
    var uri = Uri.parse("http://localhost:8080/register");
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = json.encode({
      'email': user.email,
      'pwd': user.pwd,
      'loginid': user.loginid,
      'name': user.name,
      'age': user.age,
      'sex': user.sex,
      'phone': user.phone,
      'designation': user.designation,
      'qualification': user.qualification,
      'user_type': user.user_type,
      'active': user.active,
    });
    if (kDebugMode) {
      print("**************************   REQUEST   **************************");
      print(body);
      print("*****************************************************************");
    }
    var response = await http.post(uri, headers: headers, body: body);
    if (kDebugMode) {
      print('');
      print("**************************   RESPONSE   **************************");
      print(response.body);
      print("******************************************************************");
    }
    return response;
  }
}
