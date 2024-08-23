import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/features/auth/login/login_view_model.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/toast_service.dart';

final resetPasswordViewModelProvider =
    ChangeNotifierProvider.autoDispose<ResetPasswordViewModel>(
        (ref) => ResetPasswordViewModel());

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();

  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController passwordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();

  Future<void> resetPassword(context) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        isLoading = true;
        notifyListeners();
        await _authService.resetPassword(
            passwordController.text, reenterPasswordController.text);
        router.go('/forgot_password/reset_password');
        isLoading = false;
        notifyListeners();
      }
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
}
