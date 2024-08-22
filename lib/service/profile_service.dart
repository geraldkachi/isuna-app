import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/base_model.dart';
import 'package:isuna/models/summary_model.dart';
import 'package:isuna/service/encryption_service.dart';
import 'package:isuna/service/network_service.dart';

class ProfileService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();

  BaseModel? _baseModel;

  BaseModel? get baseModel => _baseModel;

  Future<void> toggleEmailPreference(bool? email) async {
    // Send the request to the backend
    try {
      final payload = jsonEncode({'email': email});

      final encryptedPayload = _encryptionService.encrypt(payload);

      final response = await _networkService.patch(
          '/user/v1/admin/email-notification',
          data: {'payload': encryptedPayload});
      _baseModel = BaseModel.fromJson(response);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword(
      String? currentPassword, String? newPassword) async {
    // Send the request to the backend
    try {
      final payload = jsonEncode(
          {'currentPassword': currentPassword, 'newPassword': newPassword});

      final encryptedPayload = _encryptionService.encrypt(payload);

      final response = await _networkService.patch(
          '/user/v1/admin/change-password',
          data: {'payload': encryptedPayload});
      _baseModel = BaseModel.fromJson(response);
    } on MisauException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
