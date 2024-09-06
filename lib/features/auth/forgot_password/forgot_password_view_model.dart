import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/toast_service.dart';

final forgotPasswordViewModelProvider =
    ChangeNotifierProvider.autoDispose<ForgotPasswordViewModel>(
        (ref) => ForgotPasswordViewModel());

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();

  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();

  void clearField() {
    emailController.text = '';
  }

  Future<void> forgotPassword(context) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        isLoading = true;
        notifyListeners();
        await _authService.forgotPassword(emailController.text.toLowerCase());
        // emailController.clear();
        router.go('/forgot_password/reset_password');
        // clearField();
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
