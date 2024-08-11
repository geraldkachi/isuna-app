// To parse this JSON data, do
//
//     final facilitiesModel = facilitiesModelFromJson(jsonString);

import 'dart:convert';

FacilitiesModel facilitiesModelFromJson(String str) => FacilitiesModel.fromJson(json.decode(str));

String facilitiesModelToJson(FacilitiesModel data) => json.encode(data.toJson());

class FacilitiesModel {
    final String? id;
    final String? name;
    final String? lga;
    final String? state;
    final dynamic classification;
    final dynamic isActive;
    final String? ward;
    final String? addedBy;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    FacilitiesModel({
        this.id,
        this.name,
        this.lga,
        this.state,
        this.classification,
        this.isActive,
        this.ward,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory FacilitiesModel.fromJson(Map<String, dynamic> json) => FacilitiesModel(
        id: json["id"],
        name: json["name"],
        lga: json["lga"],
        state: json["state"],
        classification: json["classification"],
        isActive: json["isActive"],
        ward: json["ward"],
        addedBy: json["addedBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lga": lga,
        "state": state,
        "classification": classification,
        "isActive": isActive,
        "ward": ward,
        "addedBy": addedBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
    };
}
