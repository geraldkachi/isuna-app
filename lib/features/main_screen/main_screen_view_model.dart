import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/features/admin/admin_homepage.dart';
import 'package:misau/features/health/health_home_page.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/features/home/homepage.dart';
import 'package:misau/features/profile/profile_page.dart';
import 'package:misau/service/navigator_service.dart';

final mainScreenViewModelProvider =
    ChangeNotifierProvider<MainScreenViewModel>((ref) => MainScreenViewModel());

class MainScreenViewModel extends ChangeNotifier {
  final NavigatorService _navigatorService = getIt<NavigatorService>();

  int get currentIndex => _navigatorService.currentIndex;
  final List<Widget> pages = [
    const HomePage(),
    const HealthHomePage(),
    AdminHomePage(),
    ProfilePage(),
  ];

  void onTabTapped(int index) {
    _navigatorService.currentIndex = index;
    notifyListeners();
  }

  Widget getIcon(String selectedIcon, String unselectedIcon, int index) {
    return SvgPicture.asset(
      currentIndex == index ? selectedIcon : unselectedIcon,
      width: 24,
      height: 24,
    );
  }
}
