import 'dart:convert';

// Define the ExpenseAnalysis model
class ExpenseAnalysis {
  final int lastMonthExpense;
  final int currentMonthExpense;
  final int expenseDiff;

  ExpenseAnalysis({
    required this.lastMonthExpense,
    required this.currentMonthExpense,
    required this.expenseDiff,
  });

  // Convert JSON to ExpenseAnalysis object
  factory ExpenseAnalysis.fromJson(Map<String, dynamic> json) {
    return ExpenseAnalysis(
      lastMonthExpense: json['lastMonthExpense'],
      currentMonthExpense: json['currentMonthExpense'],
      expenseDiff: json['expenseDiff'],
    );
  }

  // Convert ExpenseAnalysis object to JSON
  Map<String, dynamic> toJson() {
    return {
      'lastMonthExpense': lastMonthExpense,
      'currentMonthExpense': currentMonthExpense,
      'expenseDiff': expenseDiff,
    };
  }
}