import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/activity_points/approve_student_activity.dart';
import 'package:newbie/modules/faculty_student/student_result_update_page.dart';
import 'package:newbie/modules/faculty_student/widgets/attendence_selector.dart';

import '../auth/auth_controller.dart';

class FacultyDashboard extends StatelessWidget {
  FacultyDashboard({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard'),
        actions: [
          IconButton(
            onPressed: () => authController.logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyElevatedBtn(
              'Marks Entry',
              () => Get.to(() => StudentResultUpdatePage()),
            ),
            MyElevatedBtn(
              'Approve Activity',
              () => Get.to(() => ApproveStudentActivity()),
            ),
            MyElevatedBtn(
              'Attendence',
              () => Get.to(() => AttendenceSelector()),
            ),
          ],
        ),
      ),
    );
  }
}
