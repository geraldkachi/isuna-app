import 'package:flutter/material.dart';
import 'package:misau/features/auth/login.dart';
import 'package:misau/provider/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
      title: 'Misau',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:const Color(0xffDC1C3D)),
        fontFamily: 'Manrope'
      ),
      home: const LoginPage(),
    ));
  }
}

