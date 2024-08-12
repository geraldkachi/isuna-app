// To parse this JSON data, do
//
//     final facilityBalancesModel = facilityBalancesModelFromJson(jsonString);

import 'dart:convert';

FacilityBalancesModel facilityBalancesModelFromJson(String str) => FacilityBalancesModel.fromJson(json.decode(str));

String facilityBalancesModelToJson(FacilityBalancesModel data) => json.encode(data.toJson());

class FacilityBalancesModel {
    final int? actualBalance;
    final int? pendingBalance;
    final int? totalBalance;

    FacilityBalancesModel({
        this.actualBalance,
        this.pendingBalance,
        this.totalBalance,
    });

    factory FacilityBalancesModel.fromJson(Map<String, dynamic> json) => FacilityBalancesModel(
        actualBalance: json["actualBalance"],
        pendingBalance: json["pendingBalance"],
        totalBalance: json["totalBalance"],
    );

    Map<String, dynamic> toJson() => {
        "actualBalance": actualBalance,
        "pendingBalance": pendingBalance,
        "totalBalance": totalBalance,
    };
}
