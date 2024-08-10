// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_router/go_router.dart';
import 'package:misau/features/auth/login/login.dart';
import 'package:misau/features/home/homepage.dart';
import 'package:misau/features/home/main_page.dart';
import 'package:misau/features/profile/profile_page.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => LoginPage(), routes: []),
  GoRoute(
    path: '/main_screen',
    builder: (context, state) => MainScreen(),
  ),
  GoRoute(
    path: '/home_page',
    builder: (context, state) => HomePage(),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => ProfilePage(),
  ),
]);
