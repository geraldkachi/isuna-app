import 'package:get_it/get_it.dart';
import 'package:isuna/service/admin_service.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/dashboard_service.dart';
import 'package:isuna/service/encryption_service.dart';
import 'package:isuna/service/excel_service.dart';
import 'package:isuna/service/health_facilities_service.dart';
import 'package:isuna/service/navigator_service.dart';
import 'package:isuna/service/network_service.dart';
import 'package:isuna/service/profile_service.dart';
import 'package:isuna/service/secure_storage_service.dart';
import 'package:isuna/service/shared_preference_service.dart';
import 'package:isuna/service/state_and_lga_service.dart';
import 'package:isuna/service/toast_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<NetworkService>(() => NetworkService());
  getIt.registerLazySingleton<DashboardService>(() => DashboardService());
  getIt.registerLazySingleton<HealthFacilitiesService>(
      () => HealthFacilitiesService());
  getIt.registerLazySingleton<AdminService>(() => AdminService());
  getIt.registerLazySingleton<StateAndLgaService>(() => StateAndLgaService());
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  getIt.registerLazySingleton<ToastService>(() => ToastService());
  getIt.registerLazySingleton<NavigatorService>(() => NavigatorService());
  getIt.registerLazySingleton<EncryptionService>(() => EncryptionService());
  getIt.registerLazySingleton<ExcelService>(() => ExcelService());
  getIt.registerSingleton<SharedPreferenceService>(SharedPreferenceService());

  getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService());
  print('get it setup successful');
}
