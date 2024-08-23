import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/auth/login/login_view_model.dart';
import 'package:isuna/utils/string_utils.dart';
import 'package:isuna/utils/validator.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final loginWatch = ref.watch(loginViewModelProvider);
    final loginRead = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Form(
          key: loginWatch.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/png/isuna_logo.png',
                    scale: 2.5,
                  ),
                  Text(
                    'Isuna',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  )
                ],
              ),
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
                "Let's login to your Isuna account",
                style: TextStyle(color: black500, fontSize: 15),
              ),
              const SizedBox(height: 30),
              const Text(
                "Email",
                style: TextStyle(
                  color: black500,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              TextFormField(
                controller: loginWatch.emailController,
                validator: (value) => Validator.validateEmail(value),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 15.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: grey100,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: grey100,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: black,
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Enter your email address',
                  hintStyle: const TextStyle(
                    color: grey300,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                      color: black500,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  // InkWell(
                  //   onTap: () {
                  //     context.go('/forgot_password');
                  //   },
                  //   child: Text(
                  //     "Forgot Password?",
                  //     style: TextStyle(
                  //       color: Color(0xff31AF99),
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 7),
              TextFormField(
                controller: loginWatch.passController,
                obscureText: loginWatch.obscureText,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 15.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: grey100,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: grey100,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: black,
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(
                    color: grey300,
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(
                      loginWatch.obscureText
                          ? 'assets/svg/view-off-slash-stroke-rounded.svg'
                          : 'assets/svg/view-stroke-rounded.svg',
                      width: 25.0,
                      height: 25.0,
                    ),
                    onPressed: () {
                      loginRead.togglePassword();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48.0,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    loginRead.login(context);
                    // context.go('/home_page');
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: red,
                  ),
                  child: loginWatch.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : const Text(
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
}
