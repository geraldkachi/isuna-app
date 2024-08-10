import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final VoidCallback onFilter;
  final VoidCallback onSearch;
  final VoidCallback onNotification;

  const AppHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.onFilter,
    required this.onSearch,
    required this.onNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                context.go('/profile');
              },
              child: Container(
                width: 43.0,
                height: 43.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffE7FCF0),
                ),
                child: Center(
                  child: Text(
                    (firstName.isNotEmpty ? firstName[0] : '') +
                        (lastName.isNotEmpty ? lastName[0] : ''),
                    style: TextStyle(
                      color: Color(0xff2AAC95),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0, // Adjust size if necessary
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onSearch,
              child: Container(
                width: 43.0,
                height: 43.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff313131),
                ),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/svg/search.svg',
                  height: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: onNotification,
              child: Container(
                width: 43.0,
                height: 43.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff313131),
                ),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/svg/notification.svg',
                  height: 20,
                ),
              ),
            ),
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
          ],
        ),
        const SizedBox(
          height: 26,
        ),
        Text(
          "Welcome, $firstName 👏🏻",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 23,
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
