import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/summary_model.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';

class ProfileService {
  final NetworkService _networkService = getIt<NetworkService>();
  final EncryptionService _encryptionService = getIt<EncryptionService>();


 Future<void> toggleEmailPreference()async{
      // Send the request to the backend
    try {
      final response = await _networkService.get(
        '/user/v1/admin/email-notification',
      );
      final encryptedResponsePayload = response['data'];
      debugPrint('encrypted response: $encryptedResponsePayload');
      final decryptedResponsePayload =
          _encryptionService.decrypt(encryptedResponsePayload);
      debugPrint('decrypted response: $decryptedResponsePayload');
      final List jsonDecodedPayload = json.decode(decryptedResponsePayload);
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
