import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> loadFile({String path = ".env"}) async {
  try {
    await dotenv.load(fileName: path);
    debugPrint("Loaded env variables");
  } catch (e) {
    debugPrint("Failed to load env variables: ${e.toString()}");
  }
}
