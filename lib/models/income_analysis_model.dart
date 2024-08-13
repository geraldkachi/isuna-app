import 'dart:convert';

class IncomeAnalysis {
  final dynamic lastMonthIncome;
  final dynamic currentMonthIncome;
  final dynamic incomeDiff;

  IncomeAnalysis({
    this.lastMonthIncome,
    this.currentMonthIncome,
    this.incomeDiff,
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
