// To parse this JSON data, do
//
//     final summaryModel = summaryModelFromJson(jsonString);

import 'dart:convert';

SummaryModel summaryModelFromJson(String str) => SummaryModel.fromJson(json.decode(str));

String summaryModelToJson(SummaryModel data) => json.encode(data.toJson());

class SummaryModel {
    final int? personal;
    final int? business;
    final int? facility;
    final int? admin;

    SummaryModel({
        this.personal,
        this.business,
        this.facility,
        this.admin,
    });

    factory SummaryModel.fromJson(Map<String, dynamic> json) => SummaryModel(
        personal: json["personal"],
        business: json["business"],
        facility: json["facility"],
        admin: json["admin"],
    );

    Map<String, dynamic> toJson() => {
        "personal": personal,
        "business": business,
        "facility": facility,
        "admin": admin,
    };
}
