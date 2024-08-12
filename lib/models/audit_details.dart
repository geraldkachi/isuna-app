// To parse this JSON data, do
//
//     final auditTrailsModel = auditTrailsModelFromJson(jsonString);

import 'dart:convert';

AuditTrailsModel auditTrailsModelFromJson(String str) => AuditTrailsModel.fromJson(json.decode(str));

String auditTrailsModelToJson(AuditTrailsModel data) => json.encode(data.toJson());

class AuditTrailsModel {
    final String? id;
    final String? adminId;
    final String? activity;
    final String? facility;
    final String? state;
    final String? lga;
    final Meta? meta;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    AuditTrailsModel({
        this.id,
        this.adminId,
        this.activity,
        this.facility,
        this.state,
        this.lga,
        this.meta,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory AuditTrailsModel.fromJson(Map<String, dynamic> json) => AuditTrailsModel(
        id: json["id"],
        adminId: json["adminId"],
        activity: json["activity"],
        facility: json["facility"],
        state: json["state"],
        lga: json["lga"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        deletedAt: json["deletedAt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "adminId": adminId,
        "activity": activity,
        "facility": facility,
        "state": state,
        "lga": lga,
        "meta": meta?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
    };
}

class Meta {
    final The0? the0;
    final String? adminEmail;
    final String? firstName;
    final String? lastName;

    Meta({
        this.the0,
        this.adminEmail,
        this.firstName,
        this.lastName,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        the0: json["0"] == null ? null : The0.fromJson(json["0"]),
        adminEmail: json["adminEmail"],
        firstName: json["firstName"],
        lastName: json["lastName"],
    );

    Map<String, dynamic> toJson() => {
        "0": the0?.toJson(),
        "adminEmail": adminEmail,
        "firstName": firstName,
        "lastName": lastName,
    };
}

class The0 {
    final String? incomeAmount;
    final DateTime? incomeDate;
    final String? state;
    final String? lga;
    final String? facility;
    final String? ward;
    final Income? income;
    final String? healthInstituteId;
    final String? addedBy;

    The0({
        this.incomeAmount,
        this.incomeDate,
        this.state,
        this.lga,
        this.facility,
        this.ward,
        this.income,
        this.healthInstituteId,
        this.addedBy,
    });

    factory The0.fromJson(Map<String, dynamic> json) => The0(
        incomeAmount: json["incomeAmount"],
        incomeDate: json["incomeDate"] == null ? null : DateTime.parse(json["incomeDate"]),
        state: json["state"],
        lga: json["lga"],
        facility: json["facility"],
        ward: json["ward"],
        income: json["income"] == null ? null : Income.fromJson(json["income"]),
        healthInstituteId: json["healthInstituteId"],
        addedBy: json["addedBy"],
    );

    Map<String, dynamic> toJson() => {
        "incomeAmount": incomeAmount,
        "incomeDate": incomeDate?.toIso8601String(),
        "state": state,
        "lga": lga,
        "facility": facility,
        "ward": ward,
        "income": income?.toJson(),
        "healthInstituteId": healthInstituteId,
        "addedBy": addedBy,
    };
}

class Income {
    final String? amount;
    final DateTime? date;

    Income({
        this.amount,
        this.date,
    });

    factory Income.fromJson(Map<String, dynamic> json) => Income(
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date?.toIso8601String(),
    };
}
