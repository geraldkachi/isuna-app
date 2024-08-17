// To parse this JSON data, do
//
//     final balanceIncomeModel = balanceIncomeModelFromJson(jsonString);

import 'dart:convert';

BalanceIncomeModel balanceIncomeModelFromJson(String str) =>
    BalanceIncomeModel.fromJson(json.decode(str));

String balanceIncomeModelToJson(BalanceIncomeModel data) =>
    json.encode(data.toJson());

class BalanceIncomeModel {
  final List<String>? categories;
  final List? data;

  BalanceIncomeModel({
    this.categories,
    this.data,
  });

  factory BalanceIncomeModel.fromJson(Map<String, dynamic> json) =>
      BalanceIncomeModel(
        categories: json["categories"] == null
            ? []
            : List<String>.from(json["categories"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List.from(json["data"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x)),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
      };
}
