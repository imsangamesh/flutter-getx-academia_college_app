import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newbie/core/constants/images.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/data/college_data.dart';
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
      backgroundColor: Colors.white,
      body: Obx(
        () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Integrated Student Mgmt App',
                style: GoogleFonts.quicksand(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.prim,
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                child: Image.asset(AppImages.login),
              ),
              const SizedBox(height: 20),

              /// -------------------------------------- `department`
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                child: MyDropDownWrapper(
                  DropdownButton(
                    dropdownColor: AppColors.listTile,
                    underline: MyDropDownWrapper.transparentDivider,
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
                                    ? AppTStyles.subHeading
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
                onPressed: () => authController.signInWithGoogle(
                  Role.fromStr(selectedRole()),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                  textStyle: AppTStyles.heading,
                  backgroundColor: AppColors.prim,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_circle, size: 30),
                    const SizedBox(width: 30),
                    Text('Sign up with Google', style: AppTStyles.button),
                    const SizedBox(width: 50),
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
