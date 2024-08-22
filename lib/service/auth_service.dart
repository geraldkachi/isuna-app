import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/admin_model.dart';
import 'package:isuna/models/error_model.dart';
import 'package:isuna/service/encryption_service.dart';
import 'package:isuna/service/network_service.dart';
import 'package:isuna/service/secure_storage_service.dart';

class AuthService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();
  final SecureStorageService _secureStorageService =
      getIt<SecureStorageService>();

  AdminModel? _userData;
  AdminModel? get userData => _userData;

  ErrorModel? errorModel;

  // final ApiService _apiService = ApiService();

  Future<void> login(String email, String password) async {
    try {
      // Create the payload
      final payload = jsonEncode({
        'email': email.trim(),
        'password': password.trim(),
      });

      debugPrint('Raw payload $payload');
      // Encrypt the payload
      final encryptedPayload = _encryptionService.encrypt(payload);

      // Send the encrypted payload to the backend
      final response = await _networkService.post(
        '/user/v1/admin/login',
        data: {'payload': encryptedPayload},
      );
      final encryptedResponsePayload = response['data'];
      final token = response['meta']['token'];
      debugPrint('token: $token');
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: ${decryptedResponsePayload.toString()}');
      _userData = AdminModel.fromJson(json.decode(decryptedResponsePayload));
      _secureStorageService.writeAccessToken(token: token);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _secureStorageService.deleteAccessToken();
    router.go('/');
  }
}
