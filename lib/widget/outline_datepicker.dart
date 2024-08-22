import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:isuna/app/theme/colors.dart';

class OutlineDatePicker extends StatelessWidget {
  const OutlineDatePicker({super.key, this.onTap, this.controller});

  final VoidCallback? onTap;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextField(
          controller: controller,
          enabled: false,
          decoration: InputDecoration(
              hintText: 'Select Date',
              suffixIcon: Column(
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  SvgPicture.asset(
                    'assets/svg/calendar.svg',
                    width: 20,
                    height: 30,
                  ),
                ],
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: black, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: grey50, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: black, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0)),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: black, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0)))),
    );

    // Container(
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //       border: Border.all(color: const Color(0xffE9EAEB), width: 1.5),
    //       borderRadius: BorderRadius.circular(15.0),
    //       color: const Color(0xffF1F2F4)),
    //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         selectedDate != null
    //             ? dateFormat.format(selectedDate!)
    //             : 'Select date',
    //         style: const TextStyle(
    //           color: Color(0xff121827),
    //           fontSize: 16,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //       SvgPicture.asset(
    //         'assets/svg/calendar.svg',
    //         // width: 13,
    //         height: 23,
    //       ),
    //     ],
    //   ),
    // ),
  }
}
