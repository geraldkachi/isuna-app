import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:misau/app/theme/colors.dart';

class OutlineTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isNumeric;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String Function(String?)? validator;
  const OutlineTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.isNumeric = false,
      this.suffixIcon,
      this.validator,
      this.obscureText = false})
      : super(key: key);

  @override
  State<OutlineTextField> createState() => _OutlineTextFieldState();
}

class _OutlineTextFieldState extends State<OutlineTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText!,
      keyboardType:
          widget.isNumeric ? TextInputType.number : TextInputType.text,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        hintStyle: TextStyle(
          color: Color(0xff121827).withOpacity(0.4),
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
      ),
      style: const TextStyle(
        color: Color(0xff121827),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
