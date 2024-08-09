import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  const CustomDropdown(this.options, {super.key});
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    selectedValue = widget.options.firstOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedValue,
        icon: SvgPicture.asset(
          'assets/svg/arrow_dropdown.svg',
          width: 13,
          height: 13,
        ),
        items: widget.options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
        selectedItemBuilder: (BuildContext context) {
          return widget.options.map<Widget>((String item) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${selectedValue ?? ''}  ',
                style: const TextStyle(color: Color(0xffABB5BC), fontSize: 14),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
