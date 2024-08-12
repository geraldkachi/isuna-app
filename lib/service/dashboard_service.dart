import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/balances_model.dart';
import 'package:misau/models/expense_analysis_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/income_analysis_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';

class DashboardService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();

  Balances? _balances;
  IncomeAnalysis? _incomeAnalysis;
  ExpenseAnalysis? _expenseAnalysis;
  TransactionList? _transactionList;
  ExpenseCategory? _expenseCategory;

  Balances? get balances => _balances;
  IncomeAnalysis? get incomeAnalysis => _incomeAnalysis;
  ExpenseAnalysis? get expenseAnalysis => _expenseAnalysis;
  ExpenseCategory? get expenseCategory => _expenseCategory;
  TransactionList? get transactionList => _transactionList;

  Future<void> fetchBalances() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=&lga=&facility=&section=balances',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _balances = Balances.fromJson(
          json.decode(decryptedResponsePayload.toString())['balances']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchIncome() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=&lga=&facility=&section=incomeAnalysis',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final Map<String, dynamic> jsonDecodedPayload =
          json.decode(decryptedResponsePayload);
      _incomeAnalysis = IncomeAnalysis.fromJson(
          jsonDecodedPayload['incomeAnalysis']['total']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchExpenseAnalysis() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=&lga=&facility=&section=expenseAnalysis',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final Map<String, dynamic> jsonDecodedPayload =
          json.decode(decryptedResponsePayload);
      _expenseAnalysis = ExpenseAnalysis.fromJson(
          jsonDecodedPayload['expenseAnalysis']['total']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchTranxList() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute?state&lga=&facility=',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _transactionList = TransactionList.fromJson(
          json.decode(decryptedResponsePayload.toString()));
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchExpenseCategory() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=&lga=&facility=&section=expenseCategory',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: ${encryptedResponsePayload}');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload}');
      _expenseCategory = ExpenseCategory.fromJson(
          json.decode(decryptedResponsePayload.toString())['expenseCategory']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchSummary() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/admin/summary',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final jsonDecodedPayload = json.decode(decryptedResponsePayload);
      _expenseCategory =
          ExpenseCategory.fromJson(jsonDecodedPayload['expenseCategory']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchFacilities() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/facilities?lga=&state=Plateau',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _expenseCategory = ExpenseCategory.fromJson(
          json.decode(decryptedResponsePayload.toString())['expenseCategory']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAuditTrails() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/audit-trails?state=&lga=&facility=',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _expenseCategory = ExpenseCategory.fromJson(
          json.decode(decryptedResponsePayload.toString())['expenseCategory']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
