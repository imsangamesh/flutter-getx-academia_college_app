import 'package:flutter/material.dart';
import 'package:newbie/core/themes/app_colors.dart';

class MyDropDownWrapper extends StatelessWidget {
  const MyDropDownWrapper(this.child, {this.isBorder = false, Key? key})
      : super(key: key);

  final Widget child;
  final bool isBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: isBorder == true
            ? Border.all(color: AppColors.prim.withAlpha(200), width: 0.5)
            : null,
        color: AppColors.listTile,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  static const transparentDivider =
      Divider(height: 0, color: Colors.transparent);
}
