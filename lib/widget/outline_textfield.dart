import 'package:flutter/material.dart';

class OutlineTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isNumeric;
  const OutlineTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isNumeric = false,
  }) : super(key: key);

  @override
  State<OutlineTextField> createState() => _OutlineTextFieldState();
}

class _OutlineTextFieldState extends State<OutlineTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE9EAEB), width: 1.5),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color(0xff121827).withOpacity(0.4),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: Color(0xff121827),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
