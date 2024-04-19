import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newbie/core/constants/pref_keys.dart';

class ThemeController extends GetxController {
  //
  final _box = GetStorage();
  final isDark = false.obs;

  configureTheme() {
    final isDarkMode = _box.read(PrefKeys.isDarkMode) ?? false;

    if (isDarkMode) {
      isDark(true);
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      isDark(false);
      Get.changeThemeMode(ThemeMode.light);
    }

    log(' - - - - - - Theme SetUp Complete | isDark: $isDarkMode - - - - - - ');
  }

  toggleTheme() {
    if (Get.isDarkMode) {
      /// -------------------- switching to `LIGHT`
      isDark(false);
      Get.changeThemeMode(ThemeMode.light);
      _box.write(PrefKeys.isDarkMode, false);
    } else {
      /// -------------------- switching to `DARK`
      isDark(true);
      Get.changeThemeMode(ThemeMode.dark);
      _box.write(PrefKeys.isDarkMode, true);
    }
  }
}
