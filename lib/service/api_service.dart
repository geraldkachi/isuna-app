import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:aescryptojs/aescryptojs.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/balances_model.dart';
import 'package:misau/models/expense_analysis_model.dart';
import 'package:misau/models/expense_category.dart';
import 'package:misau/models/income_analysis_model.dart';
import 'package:misau/models/tranx_list_model.dart';

class ApiService {
  final String baseUrl = 'https://misau-gateway.fly.dev';

  // Encryption key and IV
  final String encryptionKey = '1234567890poiuyioii';

  Future<AdminModel> login(
      String email, String password, String fcmToken) async {
    final url = Uri.parse('$baseUrl/user/v1/admin/login');

    // Create the payload
    final payload = jsonEncode({'email': email, 'password': password});

    // Encrypt the payload
    final encryptedPayload = encryptAESCryptoJS(payload, encryptionKey);

    // Send the encrypted payload to the backend
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'payload': encryptedPayload}),
    );
    log(response.body.toString());
    log(response.statusCode.toString());
    log(encryptedPayload);

    if (response.statusCode == 200) {
      // Decrypt the response
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      final adminModel =
          AdminModel.fromJson(json.decode(decryptedResponsePayload.toString()));

      return adminModel.copyWith(token: responseBody['meta']['token']);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Balances?> fetchBalances(String token) async {
    final url = Uri.parse(
        '$baseUrl/wallet/v1/health-institute/overview?state=&lga=&facility=&section=balances');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return Balances.fromJson(json.decode(decryptedResponsePayload.toString())['balances']);
    } else {
      return Balances(actualBalance: 0, pendingBalance: 0, totalBalance: 0);
    }
  }


  Future<IncomeAnalysis?> fetchIncome(String token) async {
    final url = Uri.parse(
        '$baseUrl/wallet/v1/health-institute/overview?state=&lga=&facility=&section=incomeAnalysis');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return IncomeAnalysis.fromJson(json.decode(decryptedResponsePayload.toString())['incomeAnalysis']['total']);
    } else {
      return null;
    }
  }

  Future<ExpenseAnalysis?> fetchExpenseAnalysis(String token) async {
    final url = Uri.parse(
        '$baseUrl/wallet/v1/health-institute/overview?state=&lga=&facility=&section=expenseAnalysis');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return ExpenseAnalysis.fromJson(json.decode(decryptedResponsePayload.toString())['expenseAnalysis']['total']);
    } else {
      return null;
    }
  }

    Future<TransactionList?> fetchTranxList(String token) async {
    final url = Uri.parse(
        '$baseUrl/wallet/v1/health-institute?state&lga=&facility=');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return TransactionList.fromJson(json.decode(decryptedResponsePayload.toString()));
    } else {
      return null;
    }
  }

  Future<ExpenseCategory?> fetchExpenseCategory(String token) async {
    final url = Uri.parse(
        '$baseUrl/wallet/v1/health-institute/overview?state=&lga=&facility=&section=expenseCategory');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return ExpenseCategory.fromJson(json.decode(decryptedResponsePayload.toString())['expenseCategory']);
    } else {
      return null;
    }
  }

  Future<ExpenseCategory?> fetchSummary(String token) async {
    final url = Uri.parse(
        '$baseUrl/user/v1/admin/summary');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return ExpenseCategory.fromJson(json.decode(decryptedResponsePayload.toString())['expenseCategory']);
    } else {
      return null;
    }
  }

  Future<ExpenseCategory?> fetchFacilities(String token) async {
    final url = Uri.parse(
        '$baseUrl/user/v1/facilities?lga=&state=Plateau');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return ExpenseCategory.fromJson(json.decode(decryptedResponsePayload.toString())['expenseCategory']);
    } else {
      return null;
    }
  }

  Future<ExpenseCategory?> fetchAuditTrails(String token) async {
    final url = Uri.parse(
        '$baseUrl/user/v1/audit-trails?state=&lga=&facility=');

    // Send the request to the backend
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    log(response.body.toString());
    log(response.statusCode.toString());

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final encryptedResponsePayload = responseBody['data'];
      final decryptedResponsePayload =
          decryptAESCryptoJS(encryptedResponsePayload, encryptionKey);
      log(decryptedResponsePayload.toString());
      return ExpenseCategory.fromJson(json.decode(decryptedResponsePayload.toString())['expenseCategory']);
    } else {
      return null;
    }
  }
}
