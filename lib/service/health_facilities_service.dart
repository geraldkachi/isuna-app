import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/facility_balances_model.dart';
import 'package:misau/models/audit_details.dart';
import 'package:misau/models/facilities_model.dart';
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


  List<FacilitiesModel>? get facilitiesModel => _facilitiesModel;
  List<AuditTrailsModel>? get auditTrailsModel => _auditTrailsModel;
  FacilityBalancesModel? get facilityBalancesModel => _facilityBalances!;
  TransactionList? get transactionList => _transactionList;


  Future<void> fetchFacilities() async {
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
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _transactionList = TransactionList.fromJson(
          json.decode(decryptedResponsePayload.toString()));
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
