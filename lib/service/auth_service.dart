import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/smart_pay_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';
import 'package:misau/service/secure_storage_service.dart';

class AuthService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();
  final SecureStorageService _secureStorageService =
      getIt<SecureStorageService>();

  AdminModel? _userData;
  // Balances? _balances;
  // IncomeAnalysis? _incomeAnalysis;
  // ExpenseAnalysis? _expenseAnalysis;
  // ExpenseCategory? _expenseCategory;
  // TransactionList? _transactionList;
  AdminModel? get userData => _userData;
  // Balances? get balances => _balances;
  // IncomeAnalysis? get incomeAnalysis => _incomeAnalysis;
  // ExpenseAnalysis? get expenseAnalysis => _expenseAnalysis;
  // ExpenseCategory? get expenseCategory => _expenseCategory;
  // TransactionList? get transactionList => _transactionList;

  // final ApiService _apiService = ApiService();

  Future<void> login(String email, String password) async {
    try {
      // Create the payload
      final payload =
          jsonEncode({'email': email, 'password': password, 'fcmToken': ''});

      // Encrypt the payload
      final encryptedPayload = _encryptionService.encrypt(payload);

      // Send the encrypted payload to the backend
      final response = await _networkService.post(
        '/user/v1/admin/login',
        data: {'payload': encryptedPayload},
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: ${encryptedResponsePayload}');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _userData =
          AdminModel.fromJson(json.decode(decryptedResponsePayload.toString()));
      _secureStorageService.writeAccessToken(token: _userData?.token);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // void fetchWalletData() {
  //   fetchWalletOverview();
  //   fetchIncomeAnalysis();
  //   fetchExpenseAnalysis();
  //   fetchExpenseCategory();
  //   fetchTranxList();
  //   // fetchFacilities();
  // }

  // Future<void> fetchWalletOverview() async {
  //   _balances = await _apiService.fetchBalances(_userData!.token!);
  //   notifyListeners();
  // }

  // Future<void> fetchIncomeAnalysis() async {
  //   _incomeAnalysis = await _apiService.fetchIncome(_userData!.token!);
  //   notifyListeners();
  // }

  // Future<void> fetchExpenseAnalysis() async {
  //   _expenseAnalysis =
  //       await _apiService.fetchExpenseAnalysis(_userData!.token!);
  //   notifyListeners();
  // }

  // Future<void> fetchSummary() async {
  //   // _expenseAnalysis =
  //   await _apiService.fetchSummary(_userData!.token!);
  //   notifyListeners();
  // }

  // Future<void> fetchFacilities() async {
  //   // _expenseAnalysis =
  //   await _apiService.fetchFacilities(_userData!.token!);
  //   notifyListeners();
  // }

  // Future<void> fetchAuditTrails() async {
  //   // _expenseAnalysis =
  //   await _apiService.fetchAuditTrails(_userData!.token!);
  //   notifyListeners();
  // }

  // Future<void> fetchTranxList() async {
  //   _transactionList = await _apiService.fetchTranxList(_userData!.token!);
  //   notifyListeners();
  // }

  // Future<void> fetchExpenseCategory() async {
  //   _expenseCategory =
  //       await _apiService.fetchExpenseCategory(_userData!.token!);
  //   notifyListeners();
  // }
}
