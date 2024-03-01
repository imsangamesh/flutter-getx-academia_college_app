import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static const success = Color(0xFF08DF75);
  static const danger = Color(0xFFFF473A);
  static const neutral = Color(0xFFFFC107);

  static const gray = Color(0xFFAAAAAA);
  static const midgray = Color(0xFF5A5A5A);
  static const graySmoke = Color(0xDCFFFFFF);

  static const prim = Color(0xFFEBA0FF);
  static const mid = Color(0xFFC85CE6);

  /// ------------------------------------------------------ `BUTTONS`
  static const outlineButton = Color(0xFFEBA0FF);
  static const elevatedButton = Color(0xFF03071B);

  /// ------------------------------------------------------ `THEMED COLORS`
  static Color get scaffold =>
      Get.isDarkMode ? const Color(0xFF03071B) : const Color(0xfffbedff);
  static Color get listTile =>
      Get.isDarkMode ? const Color(0xFF16002B) : const Color(0xFFF7DBFF);

  static Color get oppScaffold =>
      Get.isDarkMode ? const Color(0xfffbedff) : const Color(0xFF03071B);

  /// ------------------------------------------------------ `LIGHT THEME`
  static const lightScaffoldBG = Color(0xfffbedff);
  static const lightListTile = Color(0xFFF7DBFF);

  /// ------------------------------------------------------ `DARK THEME`
  static const darkScaffoldBG = Color(0xFF03071B);
  static const darkListTile = Color(0xFF16002B);
}

// 1 playfairDisplay
// 1 berkshireSwash
// 2 quicksand
// 3 zillaSlab - M

// amatic sc
