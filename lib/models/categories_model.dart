// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
    final String? id;
    final String? name;
    final List<SubCategory>? subCategory;
    final bool? display;
    final String? addedBy;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    CategoriesModel({
        this.id,
        this.name,
        this.subCategory,
        this.display,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
        id: json["id"],
        name: json["name"],
        subCategory: json["subCategory"] == null ? [] : List<SubCategory>.from(json["subCategory"]!.map((x) => SubCategory.fromJson(x))),
        display: json["display"],
        addedBy: json["addedBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subCategory": subCategory == null ? [] : List<dynamic>.from(subCategory!.map((x) => x.toJson())),
        "display": display,
        "addedBy": addedBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
    };
}

class SubCategory {
    final String? name;

    SubCategory({
        this.name,
    });

    factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
