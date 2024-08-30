// To parse this JSON data, do
//
//     final expenseCategoryAndSubCategoryModel = expenseCategoryAndSubCategoryModelFromJson(jsonString);

import 'dart:convert';

ExpenseCategoryAndSubCategoryModel expenseCategoryAndSubCategoryModelFromJson(String str) => ExpenseCategoryAndSubCategoryModel.fromJson(json.decode(str));

String expenseCategoryAndSubCategoryModelToJson(ExpenseCategoryAndSubCategoryModel data) => json.encode(data.toJson());

class ExpenseCategoryAndSubCategoryModel {
    final int? totalFacilities;
    final int? totalState;
    final int? totalLga;
    final List<Datum>? data;

    ExpenseCategoryAndSubCategoryModel({
        this.totalFacilities,
        this.totalState,
        this.totalLga,
        this.data,
    });

    factory ExpenseCategoryAndSubCategoryModel.fromJson(Map<String, dynamic> json) => ExpenseCategoryAndSubCategoryModel(
        totalFacilities: json["totalFacilities"],
        totalState: json["totalState"],
        totalLga: json["totalLga"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalFacilities": totalFacilities,
        "totalState": totalState,
        "totalLga": totalLga,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final String? category;
    final String? subcategory;
    final String? amount;

    Datum({
        this.category,
        this.subcategory,
        this.amount,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        category: json["category"],
        subcategory: json["subcategory"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "category": category,
        "subcategory": subcategory,
        "amount": amount,
    };
}
