import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/smart_pay_exception.dart';
import 'package:misau/models/facilities_model.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';

class HealthFacilitiesService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();

  List<FacilitiesModel>? _facilitiesModel;

  List<FacilitiesModel>? get facilitiesModel => _facilitiesModel;

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
      // final List jsonDecodedPayload = json.decode(decryptedResponsePayload);
      // _facilitiesModel = jsonDecodedPayload
      //     .map((value) => FacilitiesModel.fromJson(value))
      //     .toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
