// To parse this JSON data, do
//
//     final balances = balancesFromJson(jsonString);

import 'dart:convert';

Balances balancesFromJson(String str) => Balances.fromJson(json.decode(str));

String balancesToJson(Balances data) => json.encode(data.toJson());

class Balances {
    final double? actualBalance;
    final double? pendingBalance;
    final double? totalBalance;
    final int? totalFacilities;
    final int? totalState;
    final int? totalLga;

    Balances({
        this.actualBalance,
        this.pendingBalance,
        this.totalBalance,
        this.totalFacilities,
        this.totalState,
        this.totalLga,
    });

    factory Balances.fromJson(Map<String, dynamic> json) => Balances(
        actualBalance: json["actualBalance"]?.toDouble(),
        pendingBalance: json["pendingBalance"]?.toDouble(),
        totalBalance: json["totalBalance"]?.toDouble(),
        totalFacilities: json["totalFacilities"],
        totalState: json["totalState"],
        totalLga: json["totalLga"],
    );

    Map<String, dynamic> toJson() => {
        "actualBalance": actualBalance,
        "pendingBalance": pendingBalance,
        "totalBalance": totalBalance,
        "totalFacilities": totalFacilities,
        "totalState": totalState,
        "totalLga": totalLga,
    };
}
