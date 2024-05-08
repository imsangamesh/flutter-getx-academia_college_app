import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/themes/theme_controller.dart';
import 'package:newbie/modules/attendence/student_attendence_analytics.dart';
import 'package:newbie/modules/auth/auth_controller.dart';
import 'package:newbie/modules/dashboard/widgets/home_helpers.dart';
import 'package:newbie/modules/result/result_analytics.dart';

import '../../core/widgets/my_buttons.dart';

class ParentDashboard extends StatelessWidget {
  ParentDashboard({super.key});

  final Map<String, dynamic> studentData = AppData.fetchData();
  final authController = Get.put(AuthController());

  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;
  get currentYear => MyHelper.semToYear(studentData['sem']);

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

          /// --------------------------------- `ABOUT STUDENT CHIPS`
          const Divider(),
          Text(
            data['parentEmail'],
            textAlign: TextAlign.center,
            style: AppTStyles.subHeading.copyWith(),
          ),

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
          const SizedBox(height: 10),

          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Chip(label: Text('${data['dept']} dept')),
              const SizedBox(width: 7),
              Chip(label: Text('${data['usn']}')),
              const SizedBox(width: 7),
              Chip(label: Text('${data['sem']} sem')),
              const SizedBox(width: 7),
              Chip(label: Text('${data['div']} div')),
            ],
          ),

          const Divider(),

          MyElevatedBtn(
            'Attendance Analysis',
            () => Get.to(
              () => const StudentAttendanceAnalytics(isParent: true),
            ),
          ),
          //
          const SizedBox(height: 15),
          MyElevatedBtn(
            'Result Analysis',
            () => Get.to(() => const ResultAnalytics()),
          ),
        ],
      ),
    );
  }
}
