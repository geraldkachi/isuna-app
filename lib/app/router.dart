// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_router/go_router.dart';
import 'package:misau/features/auth/login/login.dart';
import 'package:misau/features/home/homepage.dart';


final GoRouter router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => LoginPage(), routes: []),
  GoRoute(
    path: '/home_page',
    builder: (context, state) => HomePage(),
  ),
  
]);
