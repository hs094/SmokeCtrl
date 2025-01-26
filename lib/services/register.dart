import 'dart:async';
import 'dart:convert';
import 'package:telmed/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class RegisterUser {
  Future<List<String>> saveUser(User user) async {
    var uri = Uri.parse("http://localhost:8080/auth/signup");
    Map<String, String> headers = {"Content-Type": "application/json"};
    var body = json.encode({
      "userid": "",
      "loginid": user.loginid,
      'pwd': user.pwd,
      'email': user.email,
      "name": user.name,
      'age': user.age,
      'sex': user.sex,
      'phone': user.phone,
      'designation': user.designation,
      'qualification': user.qualification,
      'userType': user.userType,
      'active': user.active,
    });
    
    var response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      try {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<String> res = jsonResponse.map((e) => e.toString()).toList();
        return res;
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing JSON response: $e');
        }
        return [];
      }
    } else {
      return [];
    }
  }
}