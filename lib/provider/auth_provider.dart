import 'package:flutter/material.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/balances_model.dart';
import 'package:misau/models/expense_analysis_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/income_analysis_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/api_service.dart';

class AuthProvider with ChangeNotifier {
  AdminModel? _userData;
  Balances? _balances;
  IncomeAnalysis? _incomeAnalysis;
  ExpenseAnalysis? _expenseAnalysis;
  ExpenseCategory? _expenseCategory;
  TransactionList? _transactionList;
  AdminModel? get userData => _userData;
  Balances? get balances => _balances;
  IncomeAnalysis? get incomeAnalysis => _incomeAnalysis;
  ExpenseAnalysis? get expenseAnalysis => _expenseAnalysis;
  ExpenseCategory? get expenseCategory => _expenseCategory;
  TransactionList? get transactionList => _transactionList;

  final ApiService _apiService = ApiService();

  Future login(String email, String password, String fcmToken) async {
    try {
      final responseData = await _apiService.login(email, password, fcmToken);
      _userData = responseData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void fetchWalletData() {
    fetchWalletOverview();
    fetchIncomeAnalysis();
    fetchExpenseAnalysis();
    fetchExpenseCategory();
    fetchTranxList();
    // fetchFacilities();
  }

  Future<void> fetchWalletOverview() async {
    _balances = await _apiService.fetchBalances(_userData!.token!);
    notifyListeners();
  }

  Future<void> fetchIncomeAnalysis() async {
    _incomeAnalysis = await _apiService.fetchIncome(_userData!.token!);
    notifyListeners();
  }

  Future<void> fetchExpenseAnalysis() async {
    _expenseAnalysis =
        await _apiService.fetchExpenseAnalysis(_userData!.token!);
    notifyListeners();
  }

  Future<void> fetchSummary() async {
    // _expenseAnalysis =
    await _apiService.fetchSummary(_userData!.token!);
    notifyListeners();
  }

  Future<void> fetchFacilities() async {
    // _expenseAnalysis =
    await _apiService.fetchFacilities(_userData!.token!);
    notifyListeners();
  }

  Future<void> fetchAuditTrails() async {
    // _expenseAnalysis =
    await _apiService.fetchAuditTrails(_userData!.token!);
    notifyListeners();
  }

  Future<void> fetchTranxList() async {
    _transactionList = await _apiService.fetchTranxList(_userData!.token!);
    notifyListeners();
  }

  Future<void> fetchExpenseCategory() async {
    _expenseCategory =
        await _apiService.fetchExpenseCategory(_userData!.token!);
    notifyListeners();
  }
}
