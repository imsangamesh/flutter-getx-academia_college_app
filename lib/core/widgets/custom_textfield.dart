import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
    this.titleController,
    this.label, {
    this.maxLines = 1,
    this.icon,
    this.suffixIcon,
    this.suffixFun,
    this.radius,
    this.inputType,
    this.maxLength,
    super.key,
  });

  final String label;
  final int? maxLines;
  final IconData? icon, suffixIcon;
  final TextEditingController titleController;
  final double? radius;
  final TextInputType? inputType;
  final VoidCallback? suffixFun;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        keyboardType: inputType ?? TextInputType.text,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          counterText: '', // removes the below `maxLength` counter
          labelText: label,
          fillColor: AppColors.listTile,
          filled: true,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  size: 25,
                  color: AppColors.prim,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: suffixFun,
                  icon: Icon(
                    suffixIcon,
                    size: 25,
                    color: AppColors.prim,
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
            borderSide: const BorderSide(
              color: AppColors.prim,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(radius ?? 16),
          ),
        ),
        controller: titleController,
        maxLines: maxLines,
        maxLength: maxLength,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}
