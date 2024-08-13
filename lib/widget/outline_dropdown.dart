import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlineDropdown extends StatefulWidget {
  final List<String>? options;
  final Function(String?)? onChanged;
  const OutlineDropdown({this.options, this.onChanged, super.key});
  @override
  State<OutlineDropdown> createState() => _OutlineDropdownState();
}

class _OutlineDropdownState extends State<OutlineDropdown> {
  String? selectedValue;

  @override
  void initState() {
    selectedValue = widget.options!.isNotEmpty ? widget.options!.first : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE9EAEB), width: 1.5),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: SvgPicture.asset(
            'assets/svg/arrow_dropdown.svg',
            width: 13,
            height: 13,
            color: const Color(0xff121827),
          ),
          items: widget.options!.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                    color: Color(0xff121827),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue!;
              widget.onChanged!(newValue);
            });
          },
          selectedItemBuilder: (BuildContext context) {
            return widget.options!.map<Widget>((String item) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${selectedValue ?? ''}  ',
                  style: const TextStyle(
                      color: Color(0xff121827),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
