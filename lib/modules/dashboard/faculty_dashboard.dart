import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/themes/theme_controller.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/activity_points/approve_activity.dart';
import 'package:newbie/modules/attendence/attendence_selector.dart';
import 'package:newbie/modules/auth/auth_controller.dart';
import 'package:newbie/modules/dashboard/widgets/home_helpers.dart';
import 'package:newbie/modules/result/update_result_selector.dart';

class FacultyDashboard extends StatelessWidget {
  FacultyDashboard({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final data = AppData.fetchData();

    return GetX<ThemeController>(
      builder: (cntr) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              /// --------------------------------- `AVATAR`
              HomeAvatar(cntr.isDark()),

              /// --------------------------------- `LOTOUT & THEME`
              ThemeAndLogoutButton(cntr, authController),
            ],
          ),

          /// --------------------------------- `ABOUT ME CHIPS`
          const Divider(),
          Text(
            data['name'],
            textAlign: TextAlign.center,
            style: AppTStyles.heading.copyWith(color: AppColors.prim),
          ),
          Text(
            data['email'],
            textAlign: TextAlign.center,
            style: AppTStyles.subHeading.copyWith(),
          ),
          Chip(label: Text('${data['branch']} branch')),

          const Divider(),
          MyElevatedBtn(
            'Attendance',
            () => Get.to(() => AttendanceSelector()),
          ),
          const SizedBox(height: 15),
          MyElevatedBtn(
            'Marks Entry',
            () => Get.to(() => UpdateResultSelector()),
          ),
          const SizedBox(height: 15),
          MyElevatedBtn(
            'Approve Activity',
            () => Get.to(() => const ApproveActivity()),
          ),
        ],
      ),
    );
  }
}
