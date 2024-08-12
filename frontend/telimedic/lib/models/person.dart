import 'dart:convert';

PersonModel personFromJson(String str) =>
    PersonModel.fromJson(json.decode(str));
String personToJson(PersonModel data) => json.encode(data.toJson());

class PersonModel {
  String loginId;
  String userId;
  String pwd;
  String name;
  int age;
  String sex;
  String phoneNo;
  String email;
  String designation;
  String qualification;
  String userType;
  String active;

  PersonModel({
    required this.loginId,
    required this.userId,
    required this.pwd,
    required this.name,
    required this.age,
    required this.sex,
    required this.phoneNo,
    required this.email,
    required this.designation,
    required this.qualification,
    required this.userType,
    required this.active,
  });

  // Factory constructor to create a PersonModel from a JSON map
  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      loginId: json['loginId'],
      userId: json['userId'],
      pwd: json['pwd'],
      name: json['name'],
      age: json['age'],
      sex: json['sex'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      designation: json['designation'],
      qualification: json['qualification'],
      userType: json['userType'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'userId': userId,
      'pwd': pwd,
      'name': name,
      'age': age,
      'sex': sex,
      'phoneNo': phoneNo,
      'email': email,
      'designation': designation,
      'qualification': qualification,
      'userType': userType,
      'active': active,
    };
  }
}
