import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_colors.dart';

class MyTStyles {
  //
  /// =================================================== `16`
  // static const TextStyle reg_16 = TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w400,
  // );

  // static const TextStyle med_16 = TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w500,
  // );

  // static const TextStyle bold_16 = TextStyle(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w700,
  // );

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

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bigTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle medBody = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle medSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  /// =================================================== `appbar`
  static const TextStyle appBar = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: MyColors.black,
  );

  static quickSand(double size) => GoogleFonts.quicksand(
      textStyle: TextStyle(fontSize: size, fontWeight: FontWeight.w500));

  static final TextStyle splHeading25 = GoogleFonts.quicksand(
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