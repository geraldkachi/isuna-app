import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isuna/app/locator.dart';
import 'package:isuna/app/router.dart';
import 'package:isuna/exceptions/misau_exception.dart';
import 'package:isuna/models/error_model.dart';
import 'package:isuna/service/auth_service.dart';
import 'package:isuna/service/secure_storage_service.dart';
import 'package:isuna/service/toast_service.dart';

final loginViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginViewModel>(
        (ref) => LoginViewModel());

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final SecureStorageService _secureStorageService =
      getIt<SecureStorageService>();

  bool obscureText = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  Future login(context) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        isLoading = true;
        notifyListeners();
        await _authService.login(
            emailController.text.toLowerCase(), passController.text);
        emailController.clear();
        passController.clear();
        router.go('/main_screen');
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

  void togglePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
