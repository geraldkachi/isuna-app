// To parse this JSON data, do
//
//     final ExpenseCategoryModel = ExpenseCategoryModelFromJson(jsonString);

import 'dart:convert';

ExpenseCategoryModel ExpenseCategoryModelFromJson(String str) => ExpenseCategoryModel.fromJson(json.decode(str));

String ExpenseCategoryModelToJson(ExpenseCategoryModel data) => json.encode(data.toJson());

class ExpenseCategoryModel {
    final String? name;
    final List<String>? data;
    final int? totalFacilities;
    final int? totalState;
    final int? totalLga;
    final List<double>? records;

    ExpenseCategoryModel({
        this.name,
        this.data,
        this.totalFacilities,
        this.totalState,
        this.totalLga,
        this.records,
    });

    factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) => ExpenseCategoryModel(
        name: json["name"],
        data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
        totalFacilities: json["totalFacilities"],
        totalState: json["totalState"],
        totalLga: json["totalLga"],
        records: json["records"] == null ? [] : List<double>.from(json["records"]!.map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
        "totalFacilities": totalFacilities,
        "totalState": totalState,
        "totalLga": totalLga,
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x)),
    };
}
