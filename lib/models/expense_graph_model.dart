// To parse this JSON data, do
//
//     final ExpenseGraphModel = ExpenseGraphModelFromJson(jsonString);

import 'dart:convert';

List<ExpenseGraphModel> ExpenseGraphModelFromJson(String str) => List<ExpenseGraphModel>.from(json.decode(str).map((x) => ExpenseGraphModel.fromJson(x)));

String ExpenseGraphModelToJson(List<ExpenseGraphModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpenseGraphModel {
    final String? month;
    final List<double>? expense;

    ExpenseGraphModel({
        this.month,
        this.expense,
    });

    factory ExpenseGraphModel.fromJson(Map<String, dynamic> json) => ExpenseGraphModel(
        month: json["name"],
        expense: json["data"] == null ? [] : List<double>.from(json["data"]!.map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "name": month,
        "data": expense == null ? [] : List<dynamic>.from(expense!.map((x) => x)),
    };
}
