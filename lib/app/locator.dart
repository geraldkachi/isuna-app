import 'package:get_it/get_it.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/dashboard_service.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/network_service.dart';
import 'package:misau/service/secure_storage_service.dart';
import 'package:misau/service/toast_service.dart';


final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<NetworkService>(NetworkService());
  getIt.registerSingleton<DashboardService>(DashboardService());
  getIt.registerSingleton<ToastService>(ToastService());
  getIt.registerSingleton<EncryptionService>(EncryptionService());
  getIt.registerSingleton<SecureStorageService>(SecureStorageService());
}
