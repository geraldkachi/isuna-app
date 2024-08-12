import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/audit_details.dart';
import 'package:misau/models/facilities_model.dart';
import 'package:misau/models/facility_balances_model.dart';
import 'package:misau/models/tranx_list_model.dart';
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

  List<AuditTrailsModel> get auditTrailsModel =>
      _healthFacilitiesService.auditTrailsModel ?? [];

  List<Transaction>? get transactions =>
      _healthFacilitiesService.transactionList?.edges;

  AdminModel get userData => _authService.userData ?? AdminModel();

  FacilityBalancesModel get facilityBalancesModel =>
      _healthFacilitiesService.facilityBalancesModel ?? FacilityBalancesModel();

  TextEditingController searchController = TextEditingController();

  List<Transaction>? filteredTransactions = [];

  bool isLoading = false;
  bool onInit = false;

  void onBuild(context) {
    getAuditTrails(context);
    getFacilityOverview(context);
    fetchFacilityTransactionList(context);
  }

  void filterTransactions() {
    final query = searchController.text.toLowerCase().trim();
    if (searchController.text.isEmpty) {
      filteredTransactions =
          _healthFacilitiesService.transactionList?.edges ?? [];
    }
    filteredTransactions =
        _healthFacilitiesService.transactionList?.edges.where((transaction) {
              final category = transaction.income != null
                  ? 'Income'
                  : transaction.expense?.category ?? '';
              final facility = transaction.facility.toLowerCase();
              return category.toLowerCase().contains(query) ||
                  facility.contains(query);
            }).toList() ??
            [];
    notifyListeners();
  }

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
      onInit = true;
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

  Future<void> getFacilityOverview(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.getFacilitiesBalances(
          selectedFacility!.name!,
          selectedFacility!.state!,
          selectedFacility!.lga!);
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

  Future<void> fetchFacilityTransactionList(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _healthFacilitiesService.fetchFacilityTransactionList(
          selectedFacility!.name!,
          selectedFacility!.state!,
          selectedFacility!.lga!);
      filteredTransactions =
          _healthFacilitiesService.transactionList?.edges ?? [];
      isLoading = false;
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
