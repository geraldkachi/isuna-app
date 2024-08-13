import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/app/router.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/models/role_model.dart';
import 'package:misau/models/states_and_lga_model.dart';
import 'package:misau/service/admin_service.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/state_and_lga_service.dart';
import 'package:misau/service/toast_service.dart';
import 'package:misau/utils/utils.dart';

final adminViewModelProvider =
    ChangeNotifierProvider<AdminViewModel>((ref) => AdminViewModel());

class AdminViewModel extends ChangeNotifier {
  final ToastService _toastService = getIt<ToastService>();
  final AdminService _adminService = getIt<AdminService>();
  final AuthService _authService = getIt<AuthService>();

  AdminModel? get userData => _authService.userData;

  List<RoleModel>? get roleModel => _adminService.roleModel;

  List<AdminModel>? get adminModel => _adminService.adminModel;

  TextEditingController searchController = TextEditingController();

  List<AdminModel>? searchAdmins = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? role;

  bool obscurePassword = true;
  bool isLoading = false;
  bool onInit = false;

  List<String> get roleList =>
      roleModel!.map((value) => value.name as String).toList();

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> addAdmin(context) async {
    try {
      Utils.showLoadingDialog(context);
      await _adminService.addAdmin(
          firstName: firstNameController.text,
          lasName: lastNameController.text,
          email: emailController.text,
          password: passwordController.text,
          role: role);
      searchAdmins = _adminService.adminModel!;
      router.pop();
    } on MisauException catch (e) {
      router.go('/main_screen');
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      router.pop();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }

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

  Future<void> getRoles(context) async {
    try {
      await _adminService.fetchRoles();
    } on MisauException catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e) {
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');
    }
  }
}
