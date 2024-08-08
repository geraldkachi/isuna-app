import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/page/home/homepage.dart';
import 'package:misau/page/home/main_page.dart';
import 'package:misau/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/logo.svg'),
              const SizedBox(height: 26),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 29,
                  letterSpacing: -.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Let's login to your Misua account",
                style: TextStyle(color: Color(0xff6A7187), fontSize: 15),
              ),
              const SizedBox(height: 30),
              const Text(
                "Email",
                style: TextStyle(
                  color: Color(0xff6A7187),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 15.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xffE8EAED),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xffE8EAED),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xffE8EAED),
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Enter your email address',
                  hintStyle: const TextStyle(
                    color: Color(0xffC0C4CD),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                      color: Color(0xff6A7187),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xff31AF99),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              TextFormField(
                controller: _passController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 15.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xffE8EAED),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xffE8EAED),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xffE8EAED),
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(
                    color: Color(0xffC0C4CD),
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      'assets/eye_icon.svg',
                      width: 21.0,
                      height: 21.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_isLoading) {
                      await onLoginPressed(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    // primary: const Color(0xffDC1C3D),
                  ),
                  // child: _isLoading
                  //     ? const SizedBox(
                  //         width: 24,
                  //         height: 24,
                  //         child: CircularProgressIndicator(
                  //           color: Colors.white,
                  //           strokeWidth: 2.0,
                  //         ),
                  //       )
                  //     :
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onLoginPressed(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
    // if (_formKey.currentState!.validate()) {
    //   setState(() => _isLoading = true);
    //   try {
    //     await Provider.of<AuthProvider>(context, listen: false).login(
    //       _emailController.text,
    //       _passController.text,
    //       'qwerty',
    //     );
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => MainScreen()),
    //     );
    //   } catch (error) {
    //     log(error.toString());
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Invalid login credentials'),
    //       ),
    //     );
    //   } finally {
    //     setState(() => _isLoading = false);
    //   }
    // }
  }
}
