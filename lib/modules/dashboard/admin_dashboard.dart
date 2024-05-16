import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/themes/theme_controller.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/admin/send_attendence_notifications.dart';
import 'package:newbie/modules/admin/send_result_notifications.dart';
import 'package:newbie/modules/auth/auth_controller.dart';
import 'package:newbie/modules/core_data_updation/update_core_data.dart';
import 'package:newbie/modules/dashboard/widgets/home_helpers.dart';
import 'package:newbie/modules/placement/placement_tile.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final data = AppData.fetchData();

    return GetX<ThemeController>(
      builder: (cntr) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
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
            const Divider(),

            /// --------------------------------- `BUTTONS`
            MyElevatedBtn(
              'College Data Management',
              () => Get.to(() => UpdateCoreData()),
            ),
            const SizedBox(height: 10),

            MyElevatedBtn(
              'Send Result Notifications',
              () => Get.to(() => SendResultNotifications()),
            ),
            const SizedBox(height: 10),

            MyElevatedBtn(
              'Send Attendance Notifications',
              () => Get.to(() => SendAttendanceNotifications()),
            ),
            const SizedBox(height: 15),
            const PlacementTile(),
          ],
        );
      },
    );
  }
}
