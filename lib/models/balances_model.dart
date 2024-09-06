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
    final List<String>? facilites;
    final int? totalState;
    final List<String>? states;
    final int? totalLga;
    final List<String>? lgas;

    Balances({
        this.actualBalance,
        this.pendingBalance,
        this.totalBalance,
        this.totalFacilities,
        this.facilites,
        this.totalState,
        this.states,
        this.totalLga,
        this.lgas,
    });

    factory Balances.fromJson(Map<String, dynamic> json) => Balances(
        actualBalance: json["actualBalance"]?.toDouble(),
        pendingBalance: json["pendingBalance"]?.toDouble(),
        totalBalance: json["totalBalance"]?.toDouble(),
        totalFacilities: json["totalFacilities"],
        facilites: json["facilites"] == null ? [] : List<String>.from(json["facilites"]!.map((x) => x)),
        totalState: json["totalState"],
        states: json["states"] == null ? [] : List<String>.from(json["states"]!.map((x) => x)),
        totalLga: json["totalLga"],
        lgas: json["lgas"] == null ? [] : List<String>.from(json["lgas"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "actualBalance": actualBalance,
        "pendingBalance": pendingBalance,
        "totalBalance": totalBalance,
        "totalFacilities": totalFacilities,
        "facilites": facilites == null ? [] : List<dynamic>.from(facilites!.map((x) => x)),
        "totalState": totalState,
        "states": states == null ? [] : List<dynamic>.from(states!.map((x) => x)),
        "totalLga": totalLga,
        "lgas": lgas == null ? [] : List<dynamic>.from(lgas!.map((x) => x)),
    };
}
