import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/attendence/attendence_selector.dart';

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});

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
        // MyElevatedBtn(
        //   'Marks Entry',
        //   () => Get.to(() => UpdateResult()),
        // ),
        // const SizedBox(height: 15),
        // MyElevatedBtn(
        //   'Approve Activity',
        //   () => Get.to(() => const ApproveActivity()),
        // ),
      ],
    );
  }
}
