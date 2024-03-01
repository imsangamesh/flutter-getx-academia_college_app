import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbie/core/themes/app_colors.dart';

class AppTStyles {
  /// `15`
  static const TextStyle smallCaption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.mid,
  );

  /// `15`
  static const TextStyle kTS15Md = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  /// `HEADING`
  static TextStyle heading = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

  static TextStyle subHeading = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );

  /// `BODY`
  static const TextStyle body = TextStyle(fontSize: 16);

  /// *============================== `WIDGETS` =============================

  /// `APPBAR`
  static TextStyle appbar = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      color: AppColors.darkScaffoldBG,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );

  /// `BUTTONS`
  static TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Get.isDarkMode ? AppColors.prim : AppColors.darkScaffoldBG,
  );

  static const TextStyle outlineButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.prim,
  );

  static const TextStyle elevatedButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.darkScaffoldBG,
  );
}
/*
class MyTStyldes {
  //
  /// =================================================== `10`
  static const TextStyle kTS10Regular = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kTS10SemiBold = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle kTS11Regular = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kTS11Medium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS11Bold = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle kTS12Regular = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle kTS12Medium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS12Bold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle kTS13Regular = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kTS13Medium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS13SemiBold = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle kTS13Bold = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle kTS14Regular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// =================================================== `15`

  static const TextStyle kTS14Medium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS14Bold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle kTS15Medium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS16Regular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kTS16Medium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS16SemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle kTS16Bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle kTS17Regular = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kTS18Medium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS18Bold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  /// =================================================== `20`

  static const TextStyle kTS20Regular = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS20Medium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS20Bold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle kTS22Medium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS24Regular = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle kTS24Medium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS24Bold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle kTS28Regular = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle kTS28Medium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );

  /// =================================================== `30`

  static const TextStyle kTS30Medium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS30SemiBold = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle kTS30Bold = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
  );

  /// =================================================== `40`

  static const TextStyle kTS40Medium = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle kTS40SemiBold = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle kTS40Bold = TextStyle(
    fontSize: 40,
  );

  /// =================================================== `50`

  static const TextStyle kTS50Bold = TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.w700,
  );

  static quickSand(double size) => GoogleFonts.quicksand(
      textStyle: TextStyle(fontSize: size, fontWeight: FontWeight.w500));

  static final TextStyle splHeading25 = GoogleFonts.berkshireSwash(
    textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
  );

  static final TextStyle splHeading16 = GoogleFonts.amaticSc(
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
  );
}
// 1 playfairDisplay
// 1 berkshireSwash
// 2 quicksand
// 3 zillaSlab - M

// amaticSc
*/