import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:isuna/app/theme/colors.dart';
import 'package:isuna/widget/user_avarta.dart';

class AppHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final VoidCallback onFilter;
  final VoidCallback onSearch;
  final VoidCallback logout;
  final VoidCallback onNotification;

  const AppHeader(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.onFilter,
      required this.onSearch,
      required this.onNotification,
      required this.logout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/png/isuna_logo.png',
                  scale: 2.5,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Isuna',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22.0,
                      color: white100),
                )
              ],
            ),
            const Spacer(),
            // GestureDetector(
            //   onTap: onSearch,
            //   child: Container(
            //     width: 43.0,
            //     height: 43.0,
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Color(0xff313131),
            //     ),
            //     padding: const EdgeInsets.all(10),
            //     child: SvgPicture.asset(
            //       'assets/svg/search.svg',
            //       height: 20,
            //     ),
            //   ),
            // ),
            const SizedBox(
              width: 10,
            ),
            // GestureDetector(
            //   onTap: onNotification,
            //   child: Container(
            //     width: 43.0,
            //     height: 43.0,
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Color(0xff313131),
            //     ),
            //     padding: const EdgeInsets.all(10),
            //     child: SvgPicture.asset(
            //       'assets/svg/notification.svg',
            //       height: 20,
            //     ),
            //   ),
            // ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: onFilter,
              child: Container(
                width: 43.0,
                height: 43.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff313131),
                ),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/svg/filter.svg',
                  height: 20,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            GestureDetector(
              onTap: logout,
              child: Container(
                width: 43.0,
                height: 43.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff313131),
                ),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/svg/logout.svg',
                  height: 20,
                  colorFilter: ColorFilter.mode(white100, BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            UserAvarta(firstName: firstName, lastName: lastName),
          ],
        ),
        const SizedBox(
          height: 26,
        ),
        Text(
          "Welcome, $firstName 👏🏻",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: -.5,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
