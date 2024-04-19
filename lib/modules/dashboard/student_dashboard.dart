import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/api/fcm_api.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/modules/activity_points/activity_analytics.dart';
import 'package:newbie/modules/activity_points/upload_new_activity.dart';
import 'package:newbie/modules/attendence/student_attendence_analytics.dart';
import 'package:newbie/modules/placement/placement_chat_page.dart';
import 'package:newbie/modules/result/result_analytics.dart';

import '../../core/widgets/my_buttons.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard({super.key});

  final Map<String, dynamic> studentData = AppData.fetchData();

  get currentYear => MyHelper.semToYear(studentData['sem']);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyElevatedBtn(
          '$currentYear Placement Updates',
          () => Get.to(() => PlacementChatPage(currentYear)),
        ),
        //
        const SizedBox(height: 15),
        MyElevatedBtn(
          'Attendance Analysis',
          () => Get.to(() => const StudentAttendanceAnalytics()),
        ),
        //
        const SizedBox(height: 15),
        MyElevatedBtn(
          'Result Analysis',
          () => Get.to(() => const ResultAnalytics()),
        ),
        //
        const SizedBox(height: 15),
        MyElevatedBtn(
          'Upload New Activity',
          () => Get.to(() => AddNewActivity()),
        ),
        //
        const SizedBox(height: 15),
        MyElevatedBtn(
          'Activity Analysis',
          () => Get.to(() => const ActivityAnalytics()),
        ),
        const SizedBox(height: 15),
        MyOutlinedBtn('Notify', () {
          FCMApi.sendPlacemntUpdates('Final Year', 'This is the dummy body!');
        }),
      ],
    );
  }
}
