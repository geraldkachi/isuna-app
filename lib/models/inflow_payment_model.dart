// To parse this JSON data, do
//
//     final inflowPaymentModel = inflowPaymentModelFromJson(jsonString);

import 'dart:convert';

InflowPaymentModel inflowPaymentModelFromJson(String str) => InflowPaymentModel.fromJson(json.decode(str));

String inflowPaymentModelToJson(InflowPaymentModel data) => json.encode(data.toJson());

class InflowPaymentModel {
    final String? state;
    final String? lga;
    final String? facility;
    final String? incomeAmount;
    final String? status;
    final DateTime? incomeDate;
    final String? ward;
    final List<IncomeData>? income;

    InflowPaymentModel({
        this.state,
        this.lga,
        this.facility,
        this.incomeAmount,
        this.status,
        this.incomeDate,
        this.ward,
        this.income,
    });

    factory InflowPaymentModel.fromJson(Map<String, dynamic> json) => InflowPaymentModel(
        state: json["state"],
        lga: json["lga"],
        facility: json["facility"],
        incomeAmount: json["incomeAmount"],
        status: json["status"],
        incomeDate: json["incomeDate"] == null ? null : DateTime.parse(json["incomeDate"]),
        ward: json["ward"],
        income: json["income"] == null ? [] : List<IncomeData>.from(json["income"]!.map((x) => IncomeData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "state": state,
        "lga": lga,
        "facility": facility,
        "incomeAmount": incomeAmount,
        "status": status,
        "incomeDate": incomeDate?.toIso8601String(),
        "ward": ward,
        "income": income == null ? [] : List<dynamic>.from(income!.map((x) => x.toJson())),
    };
}

class IncomeData {
    final String? amount;
    final DateTime? date;

    IncomeData({
        this.amount,
        this.date,
    });

    factory IncomeData.fromJson(Map<String, dynamic> json) => IncomeData(
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date?.toIso8601String(),
    };
}
