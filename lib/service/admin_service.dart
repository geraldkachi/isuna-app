import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';

class AdminService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();

  List<AdminModel>? _adminModel;

  List<AdminModel>? get adminModel => _adminModel;

  Future<void> fetchAdmins() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/admin?search=',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      final List jsonDecodedPayload =
          json.decode(decryptedResponsePayload.toString())['edges'];
      _adminModel = jsonDecodedPayload
          .map((value) => AdminModel.fromJson(value))
          .toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
