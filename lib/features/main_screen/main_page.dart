import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/features/admin/admin_homepage.dart';
import 'package:misau/features/health/health_home_page.dart';
import 'package:misau/features/home/home_viemodel.dart';
import 'package:misau/features/home/homepage.dart';
import 'package:misau/features/main_screen/main_screen_view_model.dart';
import 'package:misau/features/profile/profile_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final mainWatch = ref.watch(mainScreenViewModelProvider);
    final mainRead = ref.read(mainScreenViewModelProvider.notifier);

    return Scaffold(
      body: mainWatch.pages[ref.watch(homeViemodelProvider).screenIndex ??
          mainWatch.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: ref.watch(homeViemodelProvider).screenIndex ??
            mainWatch.currentIndex,
        onTap: mainRead.onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: mainRead.getIcon(
              'assets/svg/selected_dashboard.svg',
              'assets/svg/unselected_dashboard.svg',
              0,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: mainRead.getIcon(
              'assets/svg/selected_facilities.svg',
              'assets/svg/unselected_facilities.svg',
              1,
            ),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: mainRead.getIcon(
              'assets/svg/selected_admin.svg',
              'assets/svg/unselected_admin.svg',
              2,
            ),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: mainRead.getIcon(
              'assets/svg/selected_profile.svg',
              'assets/svg/unselected_profile.svg',
              3,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
