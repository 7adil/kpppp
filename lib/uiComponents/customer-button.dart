import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? icon;
  final double? iconSize;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final double elevation;
  final double borderRadius;

  const CustomButton({super.key,
    required this.buttonText,
    required this.onPressed,
    this.icon,
    this.iconSize,
    this.color,
    this.textColor,
    this.iconColor,
    this.elevation = 4.0, // Default elevation
    this.borderRadius = 12.0, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: iconSize, color: iconColor ?? textColor) : null,
      label: Text(buttonText, style: TextStyle(color: textColor, fontSize: 16.0)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
        elevation: elevation, // Elevation of the button
      ),
    );
  }
}
