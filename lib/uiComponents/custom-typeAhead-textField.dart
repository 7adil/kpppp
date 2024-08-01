import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeAheadTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Future<List<String>> Function(String) suggestionsCallback;
  final String? Function(String?)? validator;
  final void Function(String) onSuggestionSelected;
  final double height; // Add this line

  TypeAheadTextField({
    required this.labelText,
    required this.controller,
    required this.suggestionsCallback,
    this.validator,
    required this.onSuggestionSelected,
    this.height = 40.0, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // Set the height here
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: TypeAheadFormField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          suggestionsCallback: suggestionsCallback,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: onSuggestionSelected,
          validator: validator,
        ),
      ),
    );
  }
}
