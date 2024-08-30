import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/features/auth/reset_password/reset_password_view_model.dart';
import 'package:isuna/features/profile/profile_view_model.dart';

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resetPasswordWatch = ref.watch(resetPasswordViewModelProvider);
    final resetPasswordRead = ref.read(resetPasswordViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F7),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/back.svg',
                    height: 16,
                    color: const Color(0xff1B1C1E),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xff1B1C1E),
                      letterSpacing: -.5,
                    ),
                  ),
                ],
              ),
              onTap: () {
                context.pop();
                resetPasswordRead.clearFields();
              },
            ),
            const SizedBox(height: 26),
            Text(
              "Password",
              style: TextStyle(
                color: black500,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: resetPasswordRead.passwordController,
              obscureText: resetPasswordRead.isPasswordVisible,
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
                    resetPasswordWatch.isPasswordVisible
                        ? 'assets/svg/view-off-slash-stroke-rounded.svg'
                        : 'assets/svg/view-stroke-rounded.svg',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onPressed: () {
                    resetPasswordRead.togglePassword();
                  },
                ),
              ),
            ),
            const SizedBox(height: 26),
            Text(
              "Re-enter Password",
              style: TextStyle(
                color: black500,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: resetPasswordWatch.reenterPasswordController,
              obscureText: resetPasswordWatch.isReenterPasswordVisible,
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
                    resetPasswordRead.isReenterPasswordVisible
                        ? 'assets/svg/view-off-slash-stroke-rounded.svg'
                        : 'assets/svg/view-stroke-rounded.svg',
                    width: 25.0,
                    height: 25.0,
                  ),
                  onPressed: () {
                    resetPasswordRead.toggleReenterPassword();
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 48.0,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  resetPasswordRead.resetPassword(context);
                  resetPasswordRead.clearFields();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: red,
                ),
                child: resetPasswordWatch.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : const Text(
                        "Update Password",
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
    );
  }
}
