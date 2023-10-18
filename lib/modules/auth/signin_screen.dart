import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbie/core/constants/my_images.dart';
import 'package:newbie/core/themes/my_colors.dart';
import 'package:newbie/core/themes/my_textstyles.dart';
import 'package:newbie/modules/auth/auth_controller.dart';

import '../../core/widgets/my_dropdown_wrapper.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final authController = Get.find<AuthController>();
  final roles = ['Student', 'Faculty', 'Admin'];
  final selectedRole = 'Student'.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.white,
      body: Obx(
        () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Integrated Student Mgmt Platform',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: ThemeColors.darkPrim,
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                child: Image.asset(MyImages.login),
              ),
              const SizedBox(height: 20),

              /// -------------------------------------- `department`
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                child: MyDropDownWrapper(
                  DropdownButton(
                    dropdownColor: ThemeColors.listTile,
                    underline: MyDropDownWrapper.transDivider,
                    isExpanded: true,
                    iconSize: 30,
                    icon: const Icon(Icons.arrow_drop_down),
                    value: selectedRole(),
                    items: roles
                        .map((String each) => DropdownMenuItem(
                              value: each,
                              child: Text(
                                '  $each',
                                style: selectedRole() == each
                                    ? TextStyle(color: ThemeColors.darkPrim)
                                    : null,
                              ),
                            ))
                        .toList(),
                    onChanged: (String? newValue) => selectedRole(newValue!),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () =>
                    authController.signInWithGoogle(selectedRole()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                  textStyle: MyTStyles.title,
                  backgroundColor: ThemeColors.prim,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle, size: 30),
                    SizedBox(width: 30),
                    Text('Sign up with Google'),
                    SizedBox(width: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
