// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_router/go_router.dart';
import 'package:misau/features/admin/add_admin.dart';
import 'package:misau/features/auth/login/login.dart';
import 'package:misau/features/health/health_details.dart';
import 'package:misau/features/health/health_home_page.dart';
import 'package:misau/features/health/record_expense_payment.dart';
import 'package:misau/features/health/record_inflow_payment.dart';
import 'package:misau/features/home/homepage.dart';
import 'package:misau/features/main_screen/main_page.dart';
import 'package:misau/features/profile/preferences.dart';
import 'package:misau/features/profile/profile_page.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => LoginPage(), routes: []),
  GoRoute(
      path: '/main_screen',
      builder: (context, state) => MainScreen(),
      routes: [
        GoRoute(
            path: 'health_details',
            builder: (context, state) => HealthDetails(),
            routes: [
              GoRoute(
                path: 'record_inflow_payment',
                builder: (context, state) => RecordInflowPayment(),
              ),
              GoRoute(
                path: 'record_expense_payment',
                builder: (context, state) => RecordExpensePayment(),
              ),
            ]),
        GoRoute(
          path: 'add_admin',
          builder: (context, state) => AddAdminPage(),
        ),
        GoRoute(
          path: 'preferences',
          builder: (context, state) => PreferencesPage(),
        ),
      ]),
]);
