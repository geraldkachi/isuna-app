import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/features/profile/profile_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends ConsumerWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              InkWell(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/back.svg',
                      height: 16,
                      color: const Color(0xff1B1C1E),
                    ),
                    const SizedBox(width: 15.0),
                    const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xff1B1C1E),
                        letterSpacing: -.5,
                      ),
                    ),
                  ],
                ),
                onTap: () => context.pop(),
              ),
              const SizedBox(height: 26),
              Expanded(
                child: WebViewWidget(
                    controller:
                        ref.watch(profileViewModelProvider).webViewController),
              ),
            ])));
  }
}
