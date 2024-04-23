import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  /// *============================== `LIGHT` =============================
  /// *============================== `LIGHT` =============================
  /// *============================== `LIGHT` =============================

  static final lightTheme = ThemeData(
    /// ----------------------------------------------------- `CORE`
    splashColor: AppColors.prim.withAlpha(150),
    colorScheme: const ColorScheme.light(primary: AppColors.prim),
    scaffoldBackgroundColor: AppColors.lScaffoldBG,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.prim,
      extendedTextStyle: AppTStyles.button,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.lScaffoldBG,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lScaffoldBG,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.lScaffoldBG,
    ),

    /// ----------------------------------------------------- `APPBAR`
    appBarTheme: const AppBarTheme().copyWith(
      titleTextStyle: AppTStyles.appbar,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.prim, size: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
    ),

    /// ----------------------------------------------------- `LIST TILE`
    listTileTheme: ListTileThemeData(
      textColor: AppColors.mid,
      iconColor: AppColors.mid,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: AppColors.lListTile,
    ),

    /// ----------------------------------------------------- `EXPANSION LIST TILE`
    expansionTileTheme: ExpansionTileThemeData(
      textColor: AppColors.mid,
      iconColor: AppColors.mid,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      collapsedBackgroundColor: AppColors.lListTile,
    ),

    /// ----------------------------------------------------- `INPUT FIELD`
    inputDecorationTheme: const InputDecorationTheme(
      suffixIconColor: AppColors.prim,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.prim, width: 2),
      ),
      activeIndicatorBorder: BorderSide(color: AppColors.prim, width: 2),
    ),

    /// ----------------------------------------------------- `DIVIDER`
    dividerTheme: const DividerThemeData(
      color: AppColors.prim,
      space: 30,
      indent: 10,
      endIndent: 10,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.prim.withAlpha(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    /// ----------------------------------------------------- `TEXT`
    textTheme: GoogleFonts.rubikTextTheme().copyWith(
      bodyMedium: const TextStyle(color: Colors.black),
      bodyLarge: const TextStyle(color: Colors.black),
      displayLarge: const TextStyle(color: Colors.black),
      displayMedium: const TextStyle(color: Colors.black),
      displaySmall: const TextStyle(color: Colors.black),
      headlineMedium: const TextStyle(color: Colors.black),
      headlineSmall: const TextStyle(color: Colors.black),
      titleLarge: const TextStyle(color: Colors.black),
      titleMedium: const TextStyle(color: Colors.black),
      titleSmall: const TextStyle(color: Colors.black),
    ),
  );

  /// *============================== `DARK` =============================
  /// *============================== `DARK` =============================
  /// *============================== `DARK` =============================

  static final darkTheme = ThemeData(
    /// ----------------------------------------------------- `CORE`
    splashColor: AppColors.mid.withAlpha(100),
    colorScheme: const ColorScheme.dark(primary: AppColors.prim),
    scaffoldBackgroundColor: AppColors.dScaffoldBG,

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.prim,
      extendedTextStyle: AppTStyles.button,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.dScaffoldBG,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.dScaffoldBG,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.dScaffoldBG,
    ),

    /// ----------------------------------------------------- `APPBAR`
    appBarTheme: const AppBarTheme().copyWith(
      titleTextStyle: AppTStyles.appbar,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.prim, size: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
    ),

    /// ----------------------------------------------------- `LIST TILE`
    listTileTheme: ListTileThemeData(
      textColor: AppColors.mid,
      iconColor: AppColors.mid,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: AppColors.dListTile,
    ),

    /// ----------------------------------------------------- `EXPANSION LIST TILE`
    expansionTileTheme: ExpansionTileThemeData(
      textColor: AppColors.mid,
      iconColor: AppColors.mid,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      collapsedBackgroundColor: AppColors.dListTile,
    ),

    /// ----------------------------------------------------- `INPUT FIELD`
    inputDecorationTheme: const InputDecorationTheme(
      suffixIconColor: AppColors.prim,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.prim, width: 2),
      ),
      activeIndicatorBorder: BorderSide(color: AppColors.prim, width: 2),
    ),

    /// ----------------------------------------------------- `DIVIDER`
    dividerTheme: const DividerThemeData(
      color: AppColors.prim,
      space: 30,
      indent: 10,
      endIndent: 10,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.dScaffoldBG.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    /// ----------------------------------------------------- `TEXT`
    textTheme: GoogleFonts.rubikTextTheme().copyWith(
      bodyMedium: const TextStyle(color: Colors.white),
      bodyLarge: const TextStyle(color: Colors.white),
      displayLarge: const TextStyle(color: Colors.white),
      displayMedium: const TextStyle(color: Colors.white),
      displaySmall: const TextStyle(color: Colors.white),
      headlineMedium: const TextStyle(color: Colors.white),
      headlineSmall: const TextStyle(color: Colors.white),
      titleLarge: const TextStyle(color: Colors.white),
      titleMedium: const TextStyle(color: Colors.white),
      titleSmall: const TextStyle(color: Colors.white),
    ),
  );
}

/*
bodyText2: const TextStyle(color: Colors.black),
bodyLarge: const TextStyle(color: Colors.black),
bodyMedium: const TextStyle(color: Colors.black),
bodySmall: const TextStyle(color: Colors.black),
bodyText1: const TextStyle(color: Colors.black),
displayLarge: const TextStyle(color: Colors.black),
displayMedium: const TextStyle(color: Colors.black),
displaySmall: const TextStyle(color: Colors.black),
headline1: const TextStyle(color: Colors.black),
headline2: const TextStyle(color: Colors.black),
headline3: const TextStyle(color: Colors.black),
headline4: const TextStyle(color: Colors.black),
headline5: const TextStyle(color: Colors.black),
headline6: const TextStyle(color: Colors.black),
headlineLarge: const TextStyle(color: Colors.black),
headlineMedium: const TextStyle(color: Colors.black),
headlineSmall: const TextStyle(color: Colors.black),
labelLarge: const TextStyle(color: Colors.black),
labelMedium: const TextStyle(color: Colors.black),
labelSmall: const TextStyle(color: Colors.black),
overline: const TextStyle(color: Colors.black),
subtitle1: const TextStyle(color: Colors.black),
subtitle2: const TextStyle(color: Colors.black),
titleLarge: const TextStyle(color: Colors.black),
titleMedium: const TextStyle(color: Colors.black),
titleSmall: const TextStyle(color: Colors.black),
*/
