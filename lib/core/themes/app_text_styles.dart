import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbie/core/themes/app_colors.dart';

class AppTStyles {
  static const TextStyle tinyCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle smallCaption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.mid,
  );

  static const TextStyle kTS15Md = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subHeading = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 16.5,
      fontWeight: FontWeight.bold,
    ),
  );

  static TextStyle get primary => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: AppColors.prim,
      );

  /// `HEADING`
  static TextStyle heading = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

  /// `BODY`
  static const TextStyle body = TextStyle(fontSize: 16);

  /// *============================== `WIDGETS` =============================

  /// `APPBAR`
  static TextStyle appbar = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      color: AppColors.prim,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

  /// `BUTTONS`
  static TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Get.isDarkMode ? AppColors.prim : AppColors.dScaffoldBG,
  );

  static const TextStyle outlineButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.prim,
  );

  static const TextStyle elevatedButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.dScaffoldBG,
  );
}

/*
// 1 playfairDisplay
// 1 berkshireSwash
// 2 quicksand
// 3 zillaSlab - M

// amaticSc
*/