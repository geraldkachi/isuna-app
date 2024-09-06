import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/features/auth/forgot_password/forgot_password_view_model.dart';
import 'package:isuna/features/auth/login/login_view_model.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/toast_service.dart';

final resetPasswordViewModelProvider =
    ChangeNotifierProvider.autoDispose<ResetPasswordViewModel>((ref) =>
        ResetPasswordViewModel(
            email: ref
                .watch(forgotPasswordViewModelProvider)
                .emailController
                .text));

class ResetPasswordViewModel extends ChangeNotifier {
  ResetPasswordViewModel({this.email});

  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isReenterPasswordVisible = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController passwordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String? email;

  void togglePassword() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleReenterPassword() {
    isReenterPasswordVisible = !isReenterPasswordVisible;
    notifyListeners();
  }

  Future<void> resetPassword(context) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        isLoading = true;
        notifyListeners();
        await _authService.resetPassword(
            passwordController.text, otpController.text, email!);
        router.go('/');
        isLoading = false;
        notifyListeners();
      }
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
      debugPrint('reset password error $e\n$stackTrace');
    }
  }

  void clearFields() {
    passwordController.text = '';
    reenterPasswordController.text = '';
  }
}
