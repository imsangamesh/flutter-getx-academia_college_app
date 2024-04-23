import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/modules/attendence/attendance_analysis_tile.dart';

class StudentAttendanceAnalytics extends StatefulWidget {
  const StudentAttendanceAnalytics({this.isParent = false, super.key});

  final bool isParent;

  @override
  State<StudentAttendanceAnalytics> createState() =>
      _StudentAttendanceAnalyticsState();
}

class _StudentAttendanceAnalyticsState
    extends State<StudentAttendanceAnalytics> {
  //
  final String usn = AppData.fetchData()['usn'];
  final RxList<Map<String, dynamic>> subjects = RxList();
  final areSubjectsSet = false.obs;

  Future<void> fetchAttendanceData() async {
    try {
      final dept = AppData.fetchData()['dept'];
      final sem = AppData.fetchData()['sem'];

      final subSnap = await fire
          .collection(FireKeys.deptSemSubjects)
          .doc('$dept-$sem')
          .get();
      final subMap = subSnap.data() ?? {};

      final totalSubjects = [];
      for (var subject in subMap['subjects'].entries) {
        totalSubjects.add(subject.key);
      }

      for (var eachSub in totalSubjects) {
        final docSnap = await fire
            .collection(FireKeys.students)
            .doc(usn)
            .collection(eachSub)
            .get();

        if (docSnap.docs.isNotEmpty) {
          final subMap = <String, dynamic>{};
          subMap['subject'] = eachSub;
          subMap['attendance'] = docSnap.docs.map((e) => e.data()).toList();

          subjects.add(subMap);
          log(subMap.toString());
          log('-----------------------------------');
        }
      }

      areSubjectsSet(true);
    } catch (e) {
      areSubjectsSet(true);
      Popup.general();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
            title: widget.isParent
                ? const Text('Student\'s Attendance')
                : const Text('My Attendance')),
        body: areSubjectsSet()
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: subjects
                        .map((subMap) => AttendanceAnalysisTile(usn, subMap))
                        .toList(),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
