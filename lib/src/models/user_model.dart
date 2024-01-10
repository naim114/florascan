import 'package:country/country.dart';
import 'package:florascan/src/models/role_model.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final DateTime? birthday;
  final String? phone;
  final String? address;
  final Country? country;
  final String? avatarPath;
  final String? avatarURL;
  final RoleModel? role;
  final String? bio;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? disableAt;

  @protected
  final String password;

  UserModel({
    required this.id,
    required this.name,
    this.birthday,
    this.phone,
    this.address,
    this.country,
    required this.email,
    required this.password,
    this.avatarPath,
    this.avatarURL,
    required this.role,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    this.disableAt,
  });

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, birthday: $birthday, phone: $phone, address: $address, bio: $bio country: ${country?.isoShortName}, avatarPath: $avatarPath, avatarURL: $avatarURL, role: $role, createdAt: $createdAt, updatedAt: $updatedAt, disableAt: $disableAt, password: $password)';
  }

  UserModel.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          email: json['email']! as String,
          name: json['name']! as String,
          birthday: json['birthday']! as DateTime,
          phone: json['phone']! as String,
          address: json['address']! as String,
          bio: json['bio']! as String,
          country: json['country']! as Country,
          avatarPath: json['avatarPath']! as String,
          avatarURL: json['avatarURL']! as String,
          role: json['role']! as RoleModel,
          createdAt: json['createdAt']! as DateTime,
          updatedAt: json['updatedAt']! as DateTime,
          disableAt: json['disableAt']! as DateTime,
          password: json['password']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'birthday': birthday,
      'phone': phone,
      'address': address,
      'bio': bio,
      'country': country == null ? '458' : country?.number,
      'avatarPath': avatarPath,
      'avatarURL': avatarURL,
      'role': role?.id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'disableAt': disableAt,
      'password': password,
    };
  }
}
