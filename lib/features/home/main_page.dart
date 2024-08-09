import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:misau/features/admin/admin_homepage.dart';
import 'package:misau/features/health/health_home_page.dart';
import 'package:misau/features/home/homepage.dart';
import 'package:misau/features/profile/profile_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const HealthHomePage(),
    AdminHomePage(),
    ProfilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getIcon(String selectedIcon, String unselectedIcon, int index) {
    return SvgPicture.asset(
      _currentIndex == index ? selectedIcon : unselectedIcon,
      width: 24,
      height: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: _getIcon(
              'assets/svg/selected_dashboard.svg',
              'assets/svg/unselected_dashboard.svg',
              0,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: _getIcon(
              'assets/svg/selected_facilities.svg',
              'assets/svg/unselected_facilities.svg',
              1,
            ),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: _getIcon(
              'assets/svg/selected_admin.svg',
              'assets/svg/unselected_admin.svg',
              2,
            ),
            label: 'Admin',
          ),
          BottomNavigationBarItem(
            icon: _getIcon(
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
