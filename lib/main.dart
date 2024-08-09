import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misau/app/locator.dart';
import 'package:misau/app/router.dart';
import 'package:misau/features/auth/login/login.dart';
import 'package:misau/provider/auth_provider.dart';
import 'package:misau/utils/env_utils.dart';

void main() async {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
  setup();
  await loadFile();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Misau',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffDC1C3D)),
          fontFamily: 'Manrope'),
      routerConfig: router,
    );
  }
}
