import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/balance_expense_model.dart';
import 'package:misau/models/balance_income_model.dart';
import 'package:misau/models/categories_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/expense_payment_model.dart';
import 'package:misau/models/facility_balances_model.dart';
import 'package:misau/models/audit_details.dart';
import 'package:misau/models/facilities_model.dart';
import 'package:misau/models/inflow_payment_model.dart';
import 'package:misau/models/tranx_list_model.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';

class HealthFacilitiesService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();

  List<FacilitiesModel>? _facilitiesModel;
  List<AuditTrailsModel>? _auditTrailsModel;
  FacilityBalancesModel? _facilityBalances;
  TransactionList? _transactionList;
  List<CategoriesModel>? _categoriesModel;
  BalanceExpenseModel? _balanceExpenseModel;
  BalanceIncomeModel? _balanceIncomeModel;
  ExpenseCategory? _expenseCategory;

  List<FacilitiesModel>? get facilitiesModel => _facilitiesModel;
  List<AuditTrailsModel>? get auditTrailsModel => _auditTrailsModel;
  FacilityBalancesModel? get facilityBalancesModel => _facilityBalances;
  BalanceExpenseModel? get balanceExpenseModel => _balanceExpenseModel;
  BalanceIncomeModel? get balanceIncomeModel => _balanceIncomeModel;
  ExpenseCategory? get expenseCategory => _expenseCategory;

  TransactionList? get transactionList => _transactionList;
  List<CategoriesModel>? get categoriesModel => _categoriesModel;

  Future<void> fetchFacilitiesPagnated() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/facilities/all?search=&prev=&next=',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final List jsonDecodedPayload =
          json.decode(decryptedResponsePayload)['edges'];
      _facilitiesModel = jsonDecodedPayload
          .map((value) => FacilitiesModel.fromJson(value))
          .toList();
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
        '/user/v1/facilities?lga=&state=',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final List jsonDecodedPayload = json.decode(decryptedResponsePayload);
      _facilitiesModel = jsonDecodedPayload
          .map((value) => FacilitiesModel.fromJson(value))
          .toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAuditTrails(String facility, String state, String lga) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/audit-trails?state=$state&lga=$lga&facility=$facility',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final List jsonDecodedPayload =
          json.decode(decryptedResponsePayload)['edges'];
      _auditTrailsModel = jsonDecodedPayload
          .map((value) => AuditTrailsModel.fromJson(value))
          .toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getFacilitiesBalances(
      String facility, String state, String lga) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
          '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=balances');
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final Map<String, dynamic> jsonDecodedPayload =
          json.decode(decryptedResponsePayload);
      _facilityBalances =
          FacilityBalancesModel.fromJson(jsonDecodedPayload['balances']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getBalanceIncome(
      String facility, String state, String lga) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
          '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=balanceIncome');
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final Map<String, dynamic> jsonDecodedPayload =
          json.decode(decryptedResponsePayload);
      _balanceIncomeModel =
          BalanceIncomeModel.fromJson(jsonDecodedPayload['balanceIncome']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getBalanceExpense(
      String facility, String state, String lga) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
          '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=balanceExpense');
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final Map<String, dynamic> jsonDecodedPayload =
          json.decode(decryptedResponsePayload);
      _balanceExpenseModel =
          BalanceExpenseModel.fromJson(jsonDecodedPayload['balanceExpense']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchFacilityTransactionList(
      String facility, String state, String lga) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute?state=$state&lga=$lga&facility=$facility',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload}');
      _transactionList =
          TransactionList.fromJson(json.decode(decryptedResponsePayload));
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCategories() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/categories',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload}');
      List jsonDecodedPayload = json.decode(decryptedResponsePayload);
      _categoriesModel = jsonDecodedPayload
          .map((value) => CategoriesModel.fromJson(value))
          .toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addInflow(InflowPaymentModel inflowPaymentModel) async {
    // Send the request to the backend
    try {
      debugPrint('Raw payload ${inflowPaymentModel.toJson()}');

      final encryptedPayload =
          _encryptionService.encrypt(json.encode(inflowPaymentModel.toJson()));

      final response = await _networkService.post('/wallet/v1/health-institute',
          data: {'payload': encryptedPayload});

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload}');
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addExpense(ExpensePaymentModel expensePaymentModel) async {
    // Send the request to the backend
    try {
      debugPrint('Raw payload ${expensePaymentModel.toJson()}');

      final encryptedPayload =
          _encryptionService.encrypt(json.encode(expensePaymentModel.toJson()));

      final response = await _networkService.post('/wallet/v1/health-institute',
          data: {'payload': encryptedPayload});

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload}');
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchExpenseCategory({
    String? state,
    String? lga,
    String? facility,
  }) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=expenseCategory',
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
}
