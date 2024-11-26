import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final bool showSearchIcon;
  final TextStyle? hintStyle;
  final TextEditingController? controller;

  const CustomSearchField({
    Key? key,
    required this.hintText,
    this.showSearchIcon = false,
    this.hintStyle,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFD6D6D7),
          width: 1.5,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle ??
                GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7C7C7D),
                ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            suffixIcon: showSearchIcon
                ? const Icon(
                    Icons.search,
                    size: 24,
                    color: Color(0xFF7C7C7D),
                  )
                : null,
            isDense: true,
          ),
        ),
      ),
    );
  }
}
