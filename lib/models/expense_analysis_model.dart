
// Define the ExpenseAnalysis model
class ExpenseAnalysis {
  final int? lastMonthExpense;
  final int? currentMonthExpense;
  final int? expenseDiff;

  ExpenseAnalysis({
     this.lastMonthExpense,
     this.currentMonthExpense,
     this.expenseDiff,
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