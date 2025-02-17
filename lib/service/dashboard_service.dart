import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/balances_model.dart';
import 'package:isuna/models/expense_analysis_model.dart';
import 'package:isuna/models/expense_category.dart';
import 'package:isuna/models/expense_category_and%20_sub_category_model.dart';
import 'package:isuna/models/expense_category_extract_model.dart';
import 'package:isuna/models/expense_graph_model.dart';
import 'package:isuna/models/income_analysis_model.dart';
import 'package:isuna/models/income_graph_model.dart';
import 'package:isuna/models/pie_chart_model.dart';
import 'package:isuna/models/summary_model.dart';
import 'package:isuna/models/tranx_list_model.dart';
import 'package:isuna/service/encryption_service.dart';
import 'package:isuna/service/network_service.dart';

class DashboardService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();

  Balances? _balances;
  IncomeAnalysis? _incomeAnalysis;
  ExpenseAnalysis? _expenseAnalysis;
  TransactionList? _transactionList;
  ExpenseCategoryModel? _expenseCategoryModel;
  ExpenseCategoryAndSubCategoryModel? _expenseCategoryAndSubCategoryModel;

  SummaryModel? _summaryModel;
  List<IncomeGraphModel>? _incomeGraphModel;
  List<ExpenseGraphModel>? _expenseGraphModel;
  // List<Category>? _categories;
  List<CategoryData>? _categoryDataList = [];

  Balances? get balances => _balances;
  IncomeAnalysis? get incomeAnalysis => _incomeAnalysis;
  ExpenseAnalysis? get expenseAnalysis => _expenseAnalysis;
  ExpenseCategoryModel? get expenseCategoryModel => _expenseCategoryModel;
  ExpenseCategoryAndSubCategoryModel? get expenseCategoryAndSubCategoryModel =>
      _expenseCategoryAndSubCategoryModel;
  TransactionList? get transactionList => _transactionList;
  SummaryModel? get summaryModel => _summaryModel;
  List<IncomeGraphModel>? get incomeGraphModel => _incomeGraphModel;
  List<ExpenseGraphModel>? get expenseGraphModel => _expenseGraphModel;
  List<CategoryData>? get categoryDataList => _categoryDataList;

  Future<void> fetchBalances({
    String? state,
    String? lga,
    String? facility,
  }) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=balances',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      log('decrypted response: ${decryptedResponsePayload.toString()}');
      _balances =
          Balances.fromJson(json.decode(decryptedResponsePayload)['balances']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchIncome(
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=incomeAnalysis&fromDate=$fromDate&toDate=$toDate',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final Map<String, dynamic> jsonDecodedPayload =
          json.decode(decryptedResponsePayload);
      List graphData = jsonDecodedPayload['incomeAnalysis']['graph'];
      _incomeGraphModel =
          graphData.map((value) => IncomeGraphModel.fromJson(value)).toList();
      _incomeAnalysis = IncomeAnalysis.fromJson(
          jsonDecodedPayload['incomeAnalysis']['total']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchExpenseAnalysis(
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=expenseAnalysis&fromDate=$fromDate&toDate=$toDate',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final Map<String, dynamic> jsonDecodedPayload =
          json.decode(decryptedResponsePayload);
      List graphData = jsonDecodedPayload['expenseAnalysis']['graph'];
      _expenseGraphModel =
          graphData.map((value) => ExpenseGraphModel.fromJson(value)).toList();
      _expenseAnalysis = ExpenseAnalysis.fromJson(
          jsonDecodedPayload['expenseAnalysis']['total']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchTranxList(
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? next,
      String? prev,
      String? limit,
      String? showDeleted,
      String? toDate}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute?state=$state&lga=$lga&facility=$facility&prev=$prev&next=$next&fromDate=$fromDate&toDate=$toDate&limit=$limit&showDeleted=$showDeleted',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      log('decrypted response: ${decryptedResponsePayload.toString()}');
      _transactionList =
          TransactionList.fromJson(json.decode(decryptedResponsePayload));
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> fetchDeletedTranxList(
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? next,
      String? prev,
      String? limit,
      String? toDate}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute?state=$state&lga=$lga&facility=$facility&prev=$prev&next=$next&fromDate=$fromDate&toDate=$toDate&limit=$limit&showDeleted=',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      log('decrypted response: ${decryptedResponsePayload.toString()}');
      _transactionList =
          TransactionList.fromJson(json.decode(decryptedResponsePayload));
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> fetchExpenseCategory(
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=expenseCategory&fromDate=$fromDate&toDate=$toDate',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: ${encryptedResponsePayload}');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload}');
      _expenseCategoryModel = ExpenseCategoryModel.fromJson(
          json.decode(decryptedResponsePayload)['expenseCategory']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchExpenseCategoryAndSubCategory(
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=expenseCategories&fromDate=$fromDate&toDate=$toDate',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: ${encryptedResponsePayload}');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint(
          'decrypted sub category response: ${decryptedResponsePayload}');
      _expenseCategoryAndSubCategoryModel =
          ExpenseCategoryAndSubCategoryModel.fromJson(
              json.decode(decryptedResponsePayload)['expenseCategories']);
      // _categories =  transformData(_expenseCategoryAndSubCategoryModel!.data!);
      // List<Map<String, dynamic>> jsonData =
      //     _categories!.map((category) => category.toJson()).toList();
      List expenseCatgegoryAndSubList = DataTransformer.transformData(
          _expenseCategoryAndSubCategoryModel!.data!);
      _categoryDataList = expenseCatgegoryAndSubList.map((value) {
        log('value $value');
        return CategoryData.fromMap(value);
      }).toList();
      log('categories ${DataTransformer.transformData(_expenseCategoryAndSubCategoryModel!.data!)}');
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> filterFacilities(
      {String? state,
      String? lga,
      String? facility,
      String? fromDate,
      String? toDate}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=&lga=&facility=&section=recentActivities&fromDate=$fromDate&toDate=$toDate',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _expenseCategoryModel = ExpenseCategoryModel.fromJson(json
          .decode(decryptedResponsePayload.toString())['expenseCategoryModel']);
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
      _summaryModel = SummaryModel.fromJson(jsonDecodedPayload);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAuditTrails(
      {String? state, String? lga, String? facility}) async {
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
      _expenseCategoryModel = ExpenseCategoryModel.fromJson(json
          .decode(decryptedResponsePayload.toString())['expenseCategoryModel']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
