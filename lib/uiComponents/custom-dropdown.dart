import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;

  CustomDropDown({
    required this.hintText,
    required this.items,
    this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      hint: Text(hintText),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
