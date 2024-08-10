import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/app/router.dart';
import 'package:misau/app/theme/colors.dart';
import 'package:misau/features/auth/login/login.dart';
import 'package:misau/provider/auth_provider.dart';
import 'package:misau/utils/env_utils.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  await loadFile();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
  setup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Misau',
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: red),
          fontFamily: 'Manrope'),
      routerConfig: router,
    );
  }
}
