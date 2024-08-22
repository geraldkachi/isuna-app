import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/admin_model.dart';
import 'package:isuna/models/role_model.dart';
import 'package:isuna/models/states_and_lga_model.dart';
import 'package:isuna/service/admin_service.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/state_and_lga_service.dart';
import 'package:isuna/service/toast_service.dart';
import 'package:isuna/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  String? role;

  bool obscurePassword = true;
  bool isLoading = false;
  bool onInit = false;

  List<String> get roleList =>
      roleModel!.map((value) => value.name as String).toList();

  Future<void> onBuild(context) async {
    await fetchAdmins(context);
    await getRoles(context);
  }

  void logout() => _authService.logout();

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void onRefresh(context) {
    onBuild(context);
    refreshController.refreshCompleted();
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
      router.go('/main_screen');
    } on MisauException catch (e) {
      router.pop();

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
      final String email = admin.email!;
      final String name = '${admin.firstName} ${admin.lastName}';
      return name.toLowerCase().contains(searchController.text.toLowerCase()) ||
          email.toLowerCase().contains(searchController.text.toLowerCase());
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
