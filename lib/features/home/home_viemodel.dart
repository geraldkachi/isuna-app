import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/balances_model.dart';
import 'package:misau/models/expense_analysis_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/income_analysis_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/dashboard_service.dart';
import 'package:misau/service/toast_service.dart';

final homeViemodelProvider =
    ChangeNotifierProvider<HomeViemodel>((ref) => HomeViemodel());

class HomeViemodel extends ChangeNotifier {
  final DashboardService _dashboardService = getIt<DashboardService>();
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();

  AdminModel get userData => _authService.userData ?? AdminModel();
  Balances get balances => _dashboardService.balances ?? Balances();
  IncomeAnalysis get incomeAnalysis =>
      _dashboardService.incomeAnalysis ?? IncomeAnalysis();
  ExpenseAnalysis get expenseAnalysis =>
      _dashboardService.expenseAnalysis ?? ExpenseAnalysis();
  ExpenseCategory get expenseCategory =>
      _dashboardService.expenseCategory ?? ExpenseCategory();

  TextEditingController searchController = TextEditingController();
  List<Transaction>? filteredTransactions = [];

  bool isLoading = false;
  bool onInit = false;

  void filterTransactions() {
    final query = searchController.text.toLowerCase().trim();
    if (searchController.text.isEmpty) {
      filteredTransactions = _dashboardService.transactionList?.edges ?? [];
    }
    filteredTransactions =
        _dashboardService.transactionList?.edges.where((transaction) {
              final category = transaction.income != null
                  ? 'Income'
                  : transaction.expense?.category ?? '';
              final facility = transaction.facility.toLowerCase();
              return category.toLowerCase().contains(query) ||
                  facility.contains(query);
            }).toList() ??
            [];
    notifyListeners();
  }

  Future<void> fetchWalletData(context) async {
    await fetchBalances(context);
    await fetchIncome(context);
    await fetchTranxList(context);
    await fetchExpenseAnalysis(context);
    await fetchExpenseCategory(context);
    onInit = true;
  }

  Future<void> fetchBalances(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchBalances();
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  Future<void> fetchIncome(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchIncome();
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  Future<void> fetchTranxList(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchTranxList();
      filteredTransactions = _dashboardService.transactionList?.edges ?? [];
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  Future<void> fetchExpenseAnalysis(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchExpenseAnalysis();
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  Future<void> fetchExpenseCategory(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _dashboardService.fetchExpenseCategory();
      isLoading = false;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  // double calculatePercentageIncrease(int oldValue, int newValue) {
  //   if (oldValue == 0) {
  //     if (newValue > 0) {
  //       // If oldValue is 0 and newValue is greater than 0, percentage increase is 100%
  //       return 100.0;
  //     } else {
  //       // If both oldValue and newValue are 0, percentage increase is 0%
  //       return 0.0;
  //     }
  //   }

  //   double increase = newValue.toDouble() - oldValue.toDouble();
  //   double percentageIncrease = (increase / oldValue) * 100;
  //   return percentageIncrease;
  // }

  String calculatePercentageIncrease() {
    final percentageIncrease = (incomeAnalysis.currentMonthIncome ??
            0 - incomeAnalysis.lastMonthIncome!) /
        incomeAnalysis.lastMonthIncome! *
        100;
    return percentageIncrease.abs().toStringAsFixed(1);
  }

  String calculatePercentageDecrease() {
    final percentageDecrease = (expenseAnalysis.currentMonthExpense ??
            0 - expenseAnalysis.lastMonthExpense!) /
        expenseAnalysis.lastMonthExpense! *
        100;
    return percentageDecrease.abs().toStringAsFixed(1);
  }
}
