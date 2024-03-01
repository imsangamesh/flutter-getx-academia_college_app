import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/auth/auth_controller.dart';

class ProfileScreenView extends StatelessWidget {
  ProfileScreenView({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyElevatedBtn('Logout', () => authController.logout()),
          ],
        ),
      ),
    );
  }
}
