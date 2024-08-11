import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserAvarta extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? imageUrl;

  const UserAvarta(
      {super.key,
      required this.firstName,
      required this.lastName,
      this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}