import 'package:flutter/material.dart';

import '../themes/my_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
    this.titleController,
    this.label,
    this.maxLines, {
    this.icon,
    this.suffixIcon,
    this.suffixFun,
    this.radius,
    this.inputType,
    super.key,
  });

  final String label;
  final int maxLines;
  final IconData? icon, suffixIcon;
  final TextEditingController titleController;
  final double? radius;
  final TextInputType? inputType;
  final VoidCallback? suffixFun;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        keyboardType: inputType ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          fillColor: ThemeColors.shade20,
          filled: true,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  size: 25,
                  color: ThemeColors.prim,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: suffixFun,
                  icon: Icon(
                    suffixIcon,
                    size: 25,
                    color: ThemeColors.prim,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeColors.shade200,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
        ),
        controller: titleController,
        maxLines: maxLines,
      ),
    );
  }
}
