import 'package:flutter/material.dart';
import 'package:newbie/core/themes/my_colors.dart';

class MyDropDownWrapper extends StatelessWidget {
  const MyDropDownWrapper(this.child, {Key? key}) : super(key: key);

  final Widget child;

  static const transDivider = Divider(height: 0, color: Colors.transparent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ThemeColors.shade20,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
