// To parse this JSON data, do
//
//     final balanceExpenseModel = balanceExpenseModelFromJson(jsonString);

import 'dart:convert';

BalanceExpenseModel balanceExpenseModelFromJson(String str) =>
    BalanceExpenseModel.fromJson(json.decode(str));

String balanceExpenseModelToJson(BalanceExpenseModel data) =>
    json.encode(data.toJson());

class BalanceExpenseModel {
  final List<String>? categories;
  final List? data;

  BalanceExpenseModel({
    this.categories,
    this.data,
  });

  factory BalanceExpenseModel.fromJson(Map<String, dynamic> json) =>
      BalanceExpenseModel(
        categories: json["categories"] == null
            ? []
            : List<String>.from(json["categories"]!.map((x) => x)),
        data:
            json["data"] == null ? [] : List.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x)),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
