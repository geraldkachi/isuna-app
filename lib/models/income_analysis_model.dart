import 'dart:convert';

class IncomeAnalysis {
  final int lastMonthIncome;
  final int currentMonthIncome;
  final int incomeDiff;

  IncomeAnalysis({
    required this.lastMonthIncome,
    required this.currentMonthIncome,
    required this.incomeDiff,
  });

  // Convert JSON to Total object
  factory IncomeAnalysis.fromJson(Map<String, dynamic> json) {
    return IncomeAnalysis(
      lastMonthIncome: json['lastMonthIncome'],
      currentMonthIncome: json['currentMonthIncome'],
      incomeDiff: json['incomeDiff'],
    );
  }

  // Convert Total object to JSON
  Map<String, dynamic> toJson() {
    return {
      'lastMonthIncome': lastMonthIncome,
      'currentMonthIncome': currentMonthIncome,
      'incomeDiff': incomeDiff,
    };
  }
}
