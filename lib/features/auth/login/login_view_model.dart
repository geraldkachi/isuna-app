import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/app/router.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/error_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/toast_service.dart';

final loginViewModelProvider =
    ChangeNotifierProvider<LoginViewModel>((ref) => LoginViewModel());

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();

  bool obscureText = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  Future login(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _authService.login(emailController.text, passController.text);
      router.push('/main_screen');
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

  void togglePassword() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
