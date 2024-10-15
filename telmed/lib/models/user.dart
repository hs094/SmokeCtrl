import 'dart:core';

class User {
  String userid;
  String loginid;
  String pwd;
  String name;
  String email;
  int age;
  String sex;
  String phone;
  String designation;
  String qualification;
  String userType; 
  bool active;

  User(
      this.userid,
      this.loginid,
      this.pwd,
      this.name,
      this.age,
      this.sex,
      this.phone,
      this.email,
      this.designation,
      this.qualification,
      this.userType,
      this.active,
      );

  // Factory constructor to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['userid'],
      json['loginid'],
      json['pwd'],
      json['name'],
      json['age'],
      json['sex'],
      json['phone'],
      json['email'],
      json['designation'],
      json['qualification'],
      json['userType'],
      json['active'],
    );
  }
}