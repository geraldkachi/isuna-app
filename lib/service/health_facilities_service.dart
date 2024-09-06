import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/balance_expense_model.dart';
import 'package:isuna/models/balance_income_model.dart';
import 'package:isuna/models/categories_model.dart';
import 'package:isuna/models/expense_category.dart';
import 'package:isuna/models/expense_category_and%20_sub_category_model.dart';
import 'package:isuna/models/expense_category_extract_model.dart';
import 'package:isuna/models/expense_payment_model.dart';
import 'package:isuna/models/facility_balances_model.dart';
import 'package:isuna/models/audit_details.dart';
import 'package:isuna/models/facilities_model.dart';
import 'package:isuna/models/income_analysis_model.dart';
import 'package:isuna/models/inflow_payment_model.dart';
import 'package:isuna/models/page_info_model.dart';
import 'package:isuna/models/pie_chart_model.dart';
import 'package:isuna/models/tranx_list_model.dart';
import 'package:isuna/service/encryption_service.dart';
import 'package:isuna/service/network_service.dart';

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
  ExpenseCategoryModel? _expenseCategoryModel;
  PageInfoModel? _pageInfoModel;
  IncomeAnalysis? _incomeAnalysis;
  List<CategoryData>? _categoryDataList = [];

  ExpenseCategoryAndSubCategoryModel? _expenseCategoryAndSubCategoryModel;
  List<FacilitiesModel>? get facilitiesModel => _facilitiesModel;
  List<AuditTrailsModel>? get auditTrailsModel => _auditTrailsModel;
  FacilityBalancesModel? get facilityBalancesModel => _facilityBalances;
  BalanceExpenseModel? get balanceExpenseModel => _balanceExpenseModel;
  BalanceIncomeModel? get balanceIncomeModel => _balanceIncomeModel;
  ExpenseCategoryModel? get expenseCategoryModel => _expenseCategoryModel;
  PageInfoModel? get pageInfoModel => _pageInfoModel;
  IncomeAnalysis? get incomeAnalysis => _incomeAnalysis;
  ExpenseCategoryAndSubCategoryModel? get expenseCategoryAndSubCategoryModel =>
      _expenseCategoryAndSubCategoryModel;
  List<CategoryData>? get categoryDataList => _categoryDataList;

  TransactionList? get transactionList => _transactionList;
  List<CategoriesModel>? get categoriesModel => _categoriesModel;

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
      _incomeAnalysis = IncomeAnalysis.fromJson(
          jsonDecodedPayload['incomeAnalysis']['total']);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchFacilitiesPagnated(
      {String? prev = '', String? next = '', String? search}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/facilities/all?search=$search&prev=$prev&next=$next',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final List jsonDecodedPayload =
          json.decode(decryptedResponsePayload)['edges'];
      _pageInfoModel = PageInfoModel.fromJson(
          json.decode(decryptedResponsePayload)['pageInfo']);
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

  Future<void> getBalanceIncome(String facility, String state, String lga,
      String fromDate, String toDate) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
          '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=balanceIncome&fromDate=$fromDate&toDate=$toDate');
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

  Future<void> getBalanceExpense(String facility, String state, String lga,
      String fromDate, String toDate) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
          '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=balanceExpense&fromDate=$fromDate&toDate=$toDate');
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
      {String? facility,
      String? state,
      String? lga,
      String? search,
      String? prev,
      String? next,
      String? limit}) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute?state=$state&lga=$lga&facility=$facility&prev=&next=&search=$search&limit=$limit',
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
    String? fromDate,
    String? toDate
  }) async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/wallet/v1/health-institute/overview?state=$state&lga=$lga&facility=$facility&section=expenseCategories&fromDate=$fromDate&toDate=$toDate',
      );

      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: ${encryptedResponsePayload}');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload}');
      _expenseCategoryAndSubCategoryModel =
          ExpenseCategoryAndSubCategoryModel.fromJson(
              json.decode(decryptedResponsePayload)['expenseCategories']);
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

  Future<void> flagTransaction(
      {String? id, String? status, String? reason}) async {
    // Send the request to the backend
    try {
      Map<String, dynamic> payload = {
        'status': status?.toLowerCase(),
        'reason': reason
      };
      debugPrint('Raw payload $payload');

      final encryptedPayload = _encryptionService.encrypt(json.encode(payload));

      final response = await _networkService.patch(
          '/wallet/v1/health-institute/$id/status',
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

  Future<void> deleteTransaction({String? id}) async {
    // Send the request to the backend
    try {
      final response =
          await _networkService.delete('/wallet/v1/health-institute/$id');

      final encryptedResponsePayload = response;
      // debugPrint('encrypted response: $encryptedResponsePayload');
      // final decryptedResponsePayload =
      //     _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${encryptedResponsePayload}');
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
