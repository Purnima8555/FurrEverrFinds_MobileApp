import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? name;
  String? username;
  String? phone;
  String email;
  String password;

  UserModel({
    this.userId,
    this.name,
    this.username,
    this.phone,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["userId"],
    name: json["name"],
    username: json["username"],
    phone: json["phone"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "username": username,
    "phone": phone,
    "email": email,
    "password": password,
  };

  // Setter method to set userId
  void setUserId(String uid) {
    userId = uid;
  }

  factory UserModel.fromFirebaseSnapshot(
      DocumentSnapshot<Map<String, dynamic>> json) =>
      UserModel(
        userId: json["userId"],
        name: json["name"],
        username: json["username"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
      );

  UserModel copyWith({
    String? userId,
    String? name,
    String? username,
    String? phone,
    String? email,
    String? password,
  }) =>
      UserModel(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        username: username ?? this.username,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
