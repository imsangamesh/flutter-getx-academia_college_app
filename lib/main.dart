import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newbie/core/themes/app_themes.dart';
import 'package:newbie/modules/home/home_screen.dart';

import 'core/constants/constants.dart';
import 'core/themes/theme_controller.dart';
import 'modules/auth/auth_controller.dart';
import 'modules/auth/signin_screen.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  final authController = Get.put(AuthController());

  if (!authController.isUserPresent || auth.currentUser == null) {
    runApp(MyApp(SigninScreen()));
    return;
  }

  log('------------------------- user ID: ${auth.currentUser!.uid} ----------------------');

  final themeController = Get.put(ThemeController());
  themeController.configureTheme();

  runApp(MyApp(HomeScreen()));
}

class MyApp extends StatelessWidget {
  const MyApp(this.screen, {super.key});

  final dynamic screen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Newbie',
      debugShowCheckedModeBanner: false,
      themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: screen,
    );
  }
}
// AD:C1:A1:84:84:EF:A7:D8:2B:F0:2A:6C:79:9F:69:B6:78:01:72:98
// 73:B5:77:D0:21:D2:55:83:92:1D:C9:A8:7D:28:16:AC:BA:17:70:E6:DE:1B:8A:8D:7C:FE:73:32:B3:67:C9:F7