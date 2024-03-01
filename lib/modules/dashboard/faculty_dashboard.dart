import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/activity_points/approve_activity.dart';
import 'package:newbie/modules/attendence/attendence_selector.dart';
import 'package:newbie/modules/result/update_result.dart';

import '../auth/auth_controller.dart';

class FacultyDashboard extends StatelessWidget {
  FacultyDashboard({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyElevatedBtn(
          'Attendance',
          () => Get.to(() => AttendanceSelector()),
        ),
        const SizedBox(height: 15),
        MyElevatedBtn(
          'Marks Entry',
          () => Get.to(() => UpdateResult()),
        ),
        const SizedBox(height: 15),
        MyElevatedBtn(
          'Approve Activity',
          () => Get.to(() => const ApproveActivity()),
        ),
      ],
    );
  }
}
