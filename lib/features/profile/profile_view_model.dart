import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/exceptions/misau_exception.dart';
import 'package:misau/models/admin_model.dart';
import 'package:misau/service/auth_service.dart';
import 'package:misau/service/profile_service.dart';
import 'package:misau/service/toast_service.dart';

final profileViewModelProvider =
    ChangeNotifierProvider<ProfileViewModel>((ref) => ProfileViewModel());

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService = getIt<AuthService>();
  final ToastService _toastService = getIt<ToastService>();
  final ProfileService _profileService = getIt<ProfileService>();

  AdminModel get userData => _authService.userData ?? AdminModel();

  bool isLoading = false;

  Future<void> toggleEmailPreference(context) async {
    try {
      isLoading = true;
      notifyListeners();
      await _profileService.toggleEmailPreference();
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
          title: 'Error', subTitle: 'toggle email preference error ${e.toString()}');
    }
  }
}
