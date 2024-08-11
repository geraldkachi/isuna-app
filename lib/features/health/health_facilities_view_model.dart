import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/smart_pay_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/facilities_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/health_facilities_service.dart';
import 'package:misau/service/toast_service.dart';

final healthFacilitiesViemodelProvider =
    ChangeNotifierProvider<HealthFacilitiesViewModel>(
        (ref) => HealthFacilitiesViewModel());

class HealthFacilitiesViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final HealthFacilitiesService _healthFacilitiesService =
      getIt<HealthFacilitiesService>();

  List<FacilitiesModel> get facilitiesModel =>
      _healthFacilitiesService.facilitiesModel ?? [];

  List<FacilitiesModel>? searchFacilities = [];

  FacilitiesModel? selectedFacility;

  AdminModel get userData => _authService.userData ?? AdminModel();

  TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool onInit = false;

  Future<void> fetchFacilities(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilities();
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  void getFilteredFacilities() {
    if (searchController.text.isEmpty) {
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
    }
    searchFacilities =
        _healthFacilitiesService.facilitiesModel?.where((facility) {
      return facility.name!
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<void> getAuditTrails(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getAuditTrails(selectedFacility!.name!,
          selectedFacility!.state!, selectedFacility!.lga!);
      searchFacilities = _healthFacilitiesService.facilitiesModel!;
      isLoading = false;
      onInit = true;
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

  // void getAuditTrails(){

  //          Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HealthDetails()),
  //       );
  // }
}
