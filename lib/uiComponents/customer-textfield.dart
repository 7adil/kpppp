import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? icon;
  final Color? iconColor; // Add this line
  final TextInputType? keyboardType;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final Future<Null> Function()? onTap;
  final double height; // Add this line
  final double borderRadius; // Add this line for border radius

  const CustomTextField({super.key,
    required this.labelText,
    required this.controller,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.validator,
    this.icon,
    this.iconColor, // Add this line
    this.keyboardType,
    this.enabled = true,
    this.inputFormatters,
    this.onTap,
    this.height = 40.0, // Add this line
    this.borderRadius = 12.0, // Default border radius
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height, // Set the height here
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        onTap: () async {
          if (widget.keyboardType == TextInputType.datetime) {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
              widget.controller.text = formattedDate;
            }
          }
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: widget.icon != null
              ? Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Icon(
              widget.icon,
              color: widget.iconColor ?? Colors.grey, // Use iconColor here
            ),
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 1),
            borderRadius: BorderRadius.circular(widget.borderRadius), // Use border radius here
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(widget.borderRadius), // Use border radius here
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
