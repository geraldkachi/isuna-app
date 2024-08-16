// To parse this JSON data, do
//
//     final expensePaymentModel = expensePaymentModelFromJson(jsonString);

import 'dart:convert';

ExpensePaymentModel expensePaymentModelFromJson(String str) => ExpensePaymentModel.fromJson(json.decode(str));

String expensePaymentModelToJson(ExpensePaymentModel data) => json.encode(data.toJson());

class ExpensePaymentModel {
    final String? state;
    final String? lga;
    final String? facility;
    final List<ExpenseData>? expense;
    final String? ward;

    ExpensePaymentModel({
        this.state,
        this.lga,
        this.facility,
        this.expense,
        this.ward,
    });

    factory ExpensePaymentModel.fromJson(Map<String, dynamic> json) => ExpensePaymentModel(
        state: json["state"],
        lga: json["lga"],
        facility: json["facility"],
        expense: json["expense"] == null ? [] : List<ExpenseData>.from(json["expense"]!.map((x) => ExpenseData.fromJson(x))),
        ward: json["ward"],
    );

    Map<String, dynamic> toJson() => {
        "state": state,
        "lga": lga,
        "facility": facility,
        "expense": expense == null ? [] : List<dynamic>.from(expense!.map((x) => x.toJson())),
        "ward": ward,
    };
}

class ExpenseData {
    final String? amount;
    final String? category;
    final String? subCategory;
    final String? status;
    final String? reason;
    final DateTime? date;

    ExpenseData({
        this.amount,
        this.category,
        this.subCategory,
        this.status,
        this.reason,
        this.date,
    });

    factory ExpenseData.fromJson(Map<String, dynamic> json) => ExpenseData(
        amount: json["amount"],
        category: json["category"],
        subCategory: json["subCategory"],
        status: json["status"],
        reason: json["reason"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "category": category,
        "subCategory": subCategory,
        "status": status,
        "reason": reason,
        "date": date?.toIso8601String(),
    };
}
