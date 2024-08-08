import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class OutlineDatePicker extends StatefulWidget {
  const OutlineDatePicker({super.key});

  @override
  State<OutlineDatePicker> createState() => _OutlineDatePickerState();
}

class _OutlineDatePickerState extends State<OutlineDatePicker> {
  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('d MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE9EAEB), width: 1.5),
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xffF1F2F4)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? dateFormat.format(selectedDate!)
                  : 'Select date',
              style: const TextStyle(
                color: Color(0xff121827),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SvgPicture.asset(
              'assets/calendar.svg',
              // width: 13,
              height: 23,
            ),
          ],
        ),
      ),
    );
  }
}
