import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  // Obtain shared preferences.
  SharedPreferences? prefs;

  SharedPreferenceService() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

// Save an integer value to 'counter' key.
  Future<void> setInt(key, value) async {
    
    await prefs?.setInt(key, value);
  }

  Future<void> setBool(key, value) async {
    await prefs?.setBool(key, value);
  }

  Future<void> setDouble(key, value) async {
    await prefs?.setDouble(key, value);
  }

  Future<void> setString(key, value) async {
    await prefs?.setString(key, value);
  }

  Future<void> setStringList(key, value) async {
    await prefs?.setStringList(key, value);
  }

  int? getInt(value) => prefs?.getInt(value);

  bool? getBool(value) => prefs?.getBool(value);

  double? getDouble(value) => prefs?.getDouble(value);

  String? getString(value) => prefs?.getString(value);

  List<String>? getStringList(value) => prefs?.getStringList(value);


}
