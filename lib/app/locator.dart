import 'package:get_it/get_it.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/dashboard_service.dart';
import 'package:misau/service/encryption_service.dart';
import 'package:misau/service/health_facilities_service.dart';
import 'package:misau/service/network_service.dart';
import 'package:misau/service/secure_storage_service.dart';
import 'package:misau/service/toast_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<NetworkService>(() => NetworkService());
  getIt.registerLazySingleton<DashboardService>(() => DashboardService());
  getIt.registerLazySingleton<HealthFacilitiesService>(
      () => HealthFacilitiesService());
  getIt.registerLazySingleton<ToastService>(() => ToastService());
  getIt.registerLazySingleton<EncryptionService>(() => EncryptionService());
  getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService());
  print('get it setup successful');
}
