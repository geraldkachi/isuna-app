import 'dart:convert';

class AdminModel {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? role;
  final DateTime? createdAt;
  final bool? isActive;
  final Permissions? permissions;
  final String? token;

  AdminModel({
     this.id,
     this.firstName,
     this.lastName,
     this.email,
     this.role,
     this.createdAt,
     this.isActive,
     this.permissions,
     this.token,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      role: json['role'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'isActive': isActive,
      'token': token,
    };
  }

  AdminModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? role,
    DateTime? createdAt,
    bool? isActive,
    Permissions? permissions,
    String? token,
  }) {
    return AdminModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      permissions: permissions ?? this.permissions,
      token: token ?? this.token,
    );
  }
}

class Permissions {
  final List<Permission> permissions;
  final List<String> state;
  final List<String> lga;
  final List<String> facility;

  Permissions({
    required this.permissions,
    required this.state,
    required this.lga,
    required this.facility,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) {
    var permissionsList = json['permissions'] as List;
    return Permissions(
      permissions: permissionsList
          .map((item) => Permission.fromJson(item))
          .toList(),
      state: List<String>.from(json['state']),
      lga: List<String>.from(json['lga']),
      facility: List<String>.from(json['facility']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'permissions': permissions.map((e) => e.toJson()).toList(),
      'state': state,
      'lga': lga,
      'facility': facility,
    };
  }

  Permissions copyWith({
    List<Permission>? permissions,
    List<String>? state,
    List<String>? lga,
    List<String>? facility,
  }) {
    return Permissions(
      permissions: permissions ?? this.permissions,
      state: state ?? this.state,
      lga: lga ?? this.lga,
      facility: facility ?? this.facility,
    );
  }
}

class Permission {
  final String module;
  final PermissionDetail permission;

  Permission({
    required this.module,
    required this.permission,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      module: json['module'],
      permission: PermissionDetail.fromJson(json['permission']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'permission': permission.toJson(),
    };
  }

  Permission copyWith({
    String? module,
    PermissionDetail? permission,
  }) {
    return Permission(
      module: module ?? this.module,
      permission: permission ?? this.permission,
    );
  }
}

class PermissionDetail {
  final bool canCreate;
  final bool canView;
  final bool canUpdate;
  final bool canDelete;

  PermissionDetail({
    required this.canCreate,
    required this.canView,
    required this.canUpdate,
    required this.canDelete,
  });

  factory PermissionDetail.fromJson(Map<String, dynamic> json) {
    return PermissionDetail(
      canCreate: json['canCreate'],
      canView: json['canView'],
      canUpdate: json['canUpdate'],
      canDelete: json['canDelete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canCreate': canCreate,
      'canView': canView,
      'canUpdate': canUpdate,
      'canDelete': canDelete,
    };
  }

  PermissionDetail copyWith({
    bool? canCreate,
    bool? canView,
    bool? canUpdate,
    bool? canDelete,
  }) {
    return PermissionDetail(
      canCreate: canCreate ?? this.canCreate,
      canView: canView ?? this.canView,
      canUpdate: canUpdate ?? this.canUpdate,
      canDelete: canDelete ?? this.canDelete,
    );
  }
}
