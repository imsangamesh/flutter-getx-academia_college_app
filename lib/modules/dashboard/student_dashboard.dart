import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/modules/activity_points/upload_student_activity.dart';
import 'package:newbie/modules/analytics/student_marks_analytics.dart';
import 'package:newbie/modules/auth/auth_controller.dart';

import '../../core/widgets/my_buttons.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard({super.key});

  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
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
              'Activity Points',
              () => Get.to(() => UploadStudentActivity()),
            ),
            MyElevatedBtn(
              'Graph',
              () => Get.to(() => const StudentMarksAnalytics()),
            ),
            // MyElevatedBtn(
            //   'Attendence',
            //   () => Get.to(() => AttendenceSelector()),
            // ),
          ],
        ),
      ),
    );
  }
}
