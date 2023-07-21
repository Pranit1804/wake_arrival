import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final Function(String) onTextChanged;
  final TextEditingController textEditingController;
  const PrimaryTextField({
    super.key,
    required this.textEditingController,
    required this.onTextChanged,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      onChanged: widget.onTextChanged,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search Destination',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.all(14),
        prefixIcon: Icon(
          Icons.search,
          size: 18,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
