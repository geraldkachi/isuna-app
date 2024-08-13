import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/role_model.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';

class AdminService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();

  List<AdminModel>? _adminModel;

  List<RoleModel>? _roleModel;

  List<AdminModel>? get adminModel => _adminModel;

  List<RoleModel>? get roleModel => _roleModel;

  Future<void> addAdmin(
      {String? firstName,
      String? lasName,
      String? email,
      String? password,
      String? role}) async {
    // Send the request to the backend
    try {
      // Create the payload
      final payload = jsonEncode({
        'firstName': firstName?.trim(),
        'lastName': lasName?.trim(),
        'email': email?.trim(),
        'password': password?.trim(),
        'role': role
      });

      debugPrint('Raw payload $payload');

      // Encrypt the payload
      final encryptedPayload = _encryptionService.encrypt(payload);

      final response = await _networkService
          .post('/user/v1/admin', data: {'payload': encryptedPayload});
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      // final List jsonDecodedPayload =
      //     json.decode(decryptedResponsePayload.toString())['edges'];
      // _adminModel = jsonDecodedPayload
      //     .map((value) => AdminModel.fromJson(value))
      //     .toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<void> fetchRoles() async {
    // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/role',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      final List jsonDecodedPayload =
          json.decode(decryptedResponsePayload)['edges'];
      _roleModel =
          jsonDecodedPayload.map((value) => RoleModel.fromJson(value)).toList();
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
