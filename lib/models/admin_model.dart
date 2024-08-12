// To parse this JSON data, do
//
//     final adminModel = adminModelFromJson(jsonString);

import 'dart:convert';

AdminModel adminModelFromJson(String str) => AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
    final String? id;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? phoneNumber;
    final String? password;
    final bool? isActive;
    final String? role;
    final bool? emailNotification;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    AdminModel({
        this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.password,
        this.isActive,
        this.role,
        this.emailNotification,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        password: json["password"],
        isActive: json["isActive"],
        role: json["role"],
        emailNotification: json["emailNotification"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "isActive": isActive,
        "role": role,
        "emailNotification": emailNotification,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
    };
}
