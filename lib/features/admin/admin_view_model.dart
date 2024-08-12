import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/service/admin_service.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/toast_service.dart';

final adminViewModelProvider =
    ChangeNotifierProvider<AdminViewModel>((ref) => AdminViewModel());

class AdminViewModel extends ChangeNotifier {
  final ToastService _toastService = getIt<ToastService>();
  final AdminService _adminService = getIt<AdminService>();
  final AuthService _authService = getIt<AuthService>();

  AdminModel? get userData => _authService.userData;

  List<AdminModel>? get adminModel => _adminService.adminModel;

  TextEditingController searchController = TextEditingController();

  List<AdminModel>? searchAdmins = [];

  bool isLoading = false;
  bool onInit = false;

  Future<void> fetchAdmins(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _adminService.fetchAdmins();
      searchAdmins = _adminService.adminModel!;
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

  void getFilteredAdmins() {
    if (searchController.text.isEmpty) {
      searchAdmins = _adminService.adminModel!;
    }

    searchAdmins = _adminService.adminModel?.where((admin) {
      final String name = '${admin.firstName} ${admin.lastName}';
      return name.toLowerCase().contains(searchController.text.toLowerCase());
    }).toList();
    notifyListeners();
  }
}
