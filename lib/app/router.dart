// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:go_router/go_router.dart';
import 'package:isuna/features/admin/add_admin.dart';
import 'package:isuna/features/auth/login/login.dart';
import 'package:isuna/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:isuna/features/auth/reset_password/reset_password_screen.dart';
import 'package:isuna/features/health/health_details.dart';
import 'package:isuna/features/health/health_home_page.dart';
import 'package:isuna/features/health/record_expense_payment.dart';
import 'package:isuna/features/health/record_inflow_payment.dart';
import 'package:isuna/features/home/homepage.dart';
import 'package:isuna/features/main_screen/main_page.dart';
import 'package:isuna/features/profile/change_password.dart';
import 'package:isuna/features/profile/line_manager.dart';
import 'package:isuna/features/profile/preferences.dart';
import 'package:isuna/features/profile/privacy_policy.dart';
import 'package:isuna/features/profile/profile_page.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => LoginPage(), routes: [
    GoRoute(
        path: 'forgot_password',
        builder: (context, state) => ForgotPasswordScreen(),
        routes: [
          GoRoute(
            path: 'reset_password',
            builder: (context, state) => ResetPasswordScreen(),
          ),
        ]),
  ]),
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
        GoRoute(
          path: 'change_password',
          builder: (context, state) => ChangePassword(),
        ),
        GoRoute(
          path: 'line_manager',
          builder: (context, state) => LineManager(),
        ),
        GoRoute(
          path: 'privacy_policy',
          builder: (context, state) => PrivacyPolicy(),
        ),
      ]),
]);
