// To parse this JSON data, do
//
//     final incomeGraphModel = incomeGraphModelFromJson(jsonString);

import 'dart:convert';

List<IncomeGraphModel> incomeGraphModelFromJson(String str) => List<IncomeGraphModel>.from(json.decode(str).map((x) => IncomeGraphModel.fromJson(x)));

String incomeGraphModelToJson(List<IncomeGraphModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncomeGraphModel {
    final String? month;
    final List<double>? expense;

    IncomeGraphModel({
        this.month,
        this.expense,
    });

    factory IncomeGraphModel.fromJson(Map<String, dynamic> json) => IncomeGraphModel(
        month: json["name"],
        expense: json["data"] == null ? [] : List<double>.from(json["data"]!.map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "name": month,
        "data": expense == null ? [] : List<dynamic>.from(expense!.map((x) => x)),
    };
}
