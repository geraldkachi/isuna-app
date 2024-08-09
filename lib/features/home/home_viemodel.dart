import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/balances_model.dart';
import 'package:misau/models/expense_analysis_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/income_analysis_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/dashboard_service.dart';

final homeViemodelProvider =
    ChangeNotifierProvider<HomeViemodel>((ref) => HomeViemodel());

class HomeViemodel extends ChangeNotifier {
  final DashboardService _dashboardService = getIt<DashboardService>();
  final AuthService _authService = getIt<AuthService>();

  AdminModel get userData => _authService.userData ?? AdminModel();
  Balances get balances => _dashboardService.balances ?? Balances();
  IncomeAnalysis get incomeAnalysis =>
      _dashboardService.incomeAnalysis ?? IncomeAnalysis();
  ExpenseAnalysis get expenseAnalysis =>
      _dashboardService.expenseAnalysis ?? ExpenseAnalysis();
  ExpenseCategory get expenseCategory =>
      _dashboardService.expenseCategory ?? ExpenseCategory();

  TextEditingController? searchController = TextEditingController();
  List<Transaction>? filteredTransactions = [];

  void initListener() {
    searchController?.addListener(filterTransactions);
    filteredTransactions = _dashboardService.transactionList?.edges ?? [];
  }

  void filterTransactions() {
    final query = searchController?.text.toLowerCase();
    filteredTransactions =
        _dashboardService.transactionList?.edges.where((transaction) {
              final category = transaction.income != null
                  ? 'Income'
                  : transaction.expense?.category ?? '';
              final facility = transaction.facility.toLowerCase();
              return category.toLowerCase().contains(query!) ||
                  facility.contains(query);
            }).toList() ??
            [];
  }

  void fetchWalletData() {
    _dashboardService.fetchBalances();
    _dashboardService.fetchIncome();
    _dashboardService.fetchTranxList();
    _dashboardService.fetchExpenseAnalysis();
  }

  double calculatePercentageIncrease(int oldValue, int newValue) {
    if (oldValue == 0) {
      if (newValue > 0) {
        // If oldValue is 0 and newValue is greater than 0, percentage increase is 100%
        return 100.0;
      } else {
        // If both oldValue and newValue are 0, percentage increase is 0%
        return 0.0;
      }
    }

    double increase = newValue.toDouble() - oldValue.toDouble();
    double percentageIncrease = (increase / oldValue) * 100;
    return percentageIncrease;
  }
}
