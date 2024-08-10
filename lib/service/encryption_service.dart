import 'package:aescryptojs/aescryptojs.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionService {
  final String? encryptionKey = dotenv.env['ENCRYPTION_KEY'];

  String encrypt(payload) {
    return encryptAESCryptoJS(payload, encryptionKey!);
  }

  String decrypt(reponsePayload) {
    return decryptAESCryptoJS(reponsePayload, encryptionKey!);
  }
}
