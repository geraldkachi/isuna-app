// To parse this JSON data, do
//
//     final roleModel = roleModelFromJson(jsonString);

import 'dart:convert';

RoleModel roleModelFromJson(String str) => RoleModel.fromJson(json.decode(str));

String roleModelToJson(RoleModel data) => json.encode(data.toJson());

class RoleModel {
  final String? id;
  final String? name;
  final RoleModelPermission? permission;
  final String? adminId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  RoleModel({
    this.id,
    this.name,
    this.permission,
    this.adminId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json["id"],
        name: json["name"],
        permission: json["permission"] == null
            ? null
            : RoleModelPermission.fromJson(json["permission"]),
        adminId: json["adminId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "permission": permission?.toJson(),
        "adminId": adminId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
      };
}

class RoleModelPermission {
  final List<PermissionElement>? permissions;
  final List<String>? state;
  final List<String>? lga;
  final List<String>? facility;

  RoleModelPermission({
    this.permissions,
    this.state,
    this.lga,
    this.facility,
  });

  factory RoleModelPermission.fromJson(Map<String, dynamic> json) =>
      RoleModelPermission(
        permissions: json["permissions"] == null
            ? []
            : List<PermissionElement>.from(
                json["permissions"]!.map((x) => PermissionElement.fromJson(x))),
        state: json["state"] == null
            ? []
            : List<String>.from(json["state"]!.map((x) => x)),
        lga: json["lga"] == null
            ? []
            : List<String>.from(json["lga"]!.map((x) => x)),
        facility: json["facility"] == null
            ? []
            : List<String>.from(json["facility"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x.toJson())),
        "state": state == null ? [] : List<dynamic>.from(state!.map((x) => x)),
        "lga": lga == null ? [] : List<dynamic>.from(lga!.map((x) => x)),
        "facility":
            facility == null ? [] : List<dynamic>.from(facility!.map((x) => x)),
      };
}

class PermissionElement {
  final String? module;
  final PurplePermission? permission;

  PermissionElement({
    this.module,
    this.permission,
  });

  factory PermissionElement.fromJson(Map<String, dynamic> json) =>
      PermissionElement(
        module: json["module"],
        permission: json["permission"] == null
            ? null
            : PurplePermission.fromJson(json["permission"]),
      );

  Map<String, dynamic> toJson() => {
        "module": module,
        "permission": permission?.toJson(),
      };
}

class PurplePermission {
  final bool? canCreate;
  final bool? canView;
  final bool? canUpdate;
  final bool? canDelete;

  PurplePermission({
    this.canCreate,
    this.canView,
    this.canUpdate,
    this.canDelete,
  });

  factory PurplePermission.fromJson(Map<String, dynamic> json) =>
      PurplePermission(
        canCreate: json["canCreate"],
        canView: json["canView"],
        canUpdate: json["canUpdate"],
        canDelete: json["canDelete"],
      );

  Map<String, dynamic> toJson() => {
        "canCreate": canCreate,
        "canView": canView,
        "canUpdate": canUpdate,
        "canDelete": canDelete,
      };
}
