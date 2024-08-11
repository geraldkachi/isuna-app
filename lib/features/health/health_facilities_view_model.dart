import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/smart_pay_exception.dart';
import 'package:misau/models/facilities_model.dart';
import 'package:misau/service/health_facilities_service.dart';
import 'package:misau/service/toast_service.dart';

final healthFacilitiesViemodelProvider =
    ChangeNotifierProvider<HealthFacilitiesViewModel>(
        (ref) => HealthFacilitiesViewModel());

class HealthFacilitiesViewModel extends ChangeNotifier {
  final ToastService _toastService = getIt<ToastService>();
  final HealthFacilitiesService _healthFacilitiesService =
      getIt<HealthFacilitiesService>();

  List<FacilitiesModel> get facilitiesModel =>
      _healthFacilitiesService.facilitiesModel ?? [];

  bool isLoading = false;
  bool onInit = false;

  Future<void> fetchFacilities(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilities();
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }
}
