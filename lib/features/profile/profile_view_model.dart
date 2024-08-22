import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/admin_model.dart';
import 'package:isuna/models/base_model.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/profile_service.dart';
import 'package:isuna/service/toast_service.dart';

final profileViewModelProvider =
    ChangeNotifierProvider.autoDispose<ProfileViewModel>(
        (ref) => ProfileViewModel());

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final ProfileService _profileService = getIt<ProfileService>();

  AdminModel get userData => _authService.userData ?? AdminModel();
  BaseModel? get baseModel => _profileService.baseModel;

  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();

  bool currentPassObscureText = true;
  bool newPassObscureText = true;

  bool isLoading = false;

  bool isEmailEnabled = false;

  void setInitState() {
    isEmailEnabled = _authService.userData!.emailNotification!;
  }

  void toggleCurrentPass() {
    currentPassObscureText = !currentPassObscureText;
    notifyListeners();
  }

  void toggletNewPass() {
    newPassObscureText = !newPassObscureText;
    notifyListeners();
  }

  void toggleSwitchState(value) {
    isEmailEnabled = value;
    notifyListeners();
  }

  void clearFields() {
    currentPassController.text = '';
    newPassController.text = '';
  }

  void logout() => _authService.logout();

  Future<void> toggleEmailPreference(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _profileService.toggleEmailPreference(isEmailEnabled);
      isLoading = false;
      _toastService.showToast(context,
          type: ToastType.success,
          title: 'Success',
          subTitle: baseModel!.message ?? '');
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error',
          subTitle: 'toggle email preference error ${e.toString()}');

      debugPrint('toggle email preference error ${e.toString()}/n$stackTrace');
    }
  }

  Future<void> updatePassword(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _profileService.updatePassword(
          currentPassController.text, newPassController.text);
      isLoading = false;
      _toastService.showToast(context,
          type: ToastType.success,
          title: 'Success',
          subTitle: baseModel!.message ?? '');
      notifyListeners();
    } on MisauException catch (e) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: e.message ?? '');
    } catch (e, stackTrace) {
      isLoading = false;
      notifyListeners();
      _toastService.showToast(context,
          title: 'Error', subTitle: 'Something went wrong.');

      debugPrint('update password error ${e.toString()}/n$stackTrace');
    }
  }
}
