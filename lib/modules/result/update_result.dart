import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/result/student_detail_tile.dart';

import '../../core/widgets/custom_textfield.dart';

class UpdateResult extends StatelessWidget {
  UpdateResult({super.key});

  final usnController = TextEditingController();
  final studentData = RxMap({});
  final isDataFetched = false.obs;

  final allSubjects = RxList<String>([]);
  final selectedSubject = ''.obs;

  final selectedExamType = CollegeData.exams.first.obs;
  final marksController = TextEditingController();

  /// - - - - - - - - - - - - - - - - - - - - `fetch STUDENT data`
  Future<void> getStudentData() async {
    final usn = usnController.text.trim().toUpperCase();

    if (usn.length != 10) {
      Popup.snackbar('Please provide a valid USN');
      return;
    }

    Popup.loading(label: 'Fetching student data');

    try {
      final snapshot = await fire.collection(FireKeys.students).get();
      final data = snapshot.docs
          .map((e) => e.data())
          .firstWhere((element) => element['usn'] == usn);

      studentData(data);
      log(studentData.toString());
      getStudentSubjects();
      Popup.terminateLoading();
    } catch (e) {
      Popup.terminateLoading();
      Popup.alert('Oops!', 'No data found with the provided USN');
    }
  }

  /// - - - - - - - - - - - - - - - - - - - - `fetch student SUBJECTS`
  Future<void> getStudentSubjects() async {
    try {
      Popup.loading(label: 'fetching student subjects...');

      final subjectSnap = await fire
          .collection(FireKeys.deptSemSubjects)
          .doc('${studentData['dept']}-${studentData['sem']}')
          .get();
      final subjectDataMap = subjectSnap.data();

      if (subjectDataMap == null || subjectDataMap['subjects'].keys.isEmpty) {
        Popup.alert(
          'Oops!',
          'No subjects found for the provided student USN.',
        );
        Popup.terminateLoading();
        return;
      }

      allSubjects([]);
      for (var subCode in subjectDataMap['subjects'].keys) {
        allSubjects.add(subCode);
      }

      selectedSubject(allSubjects[0]);
      isDataFetched(true);
      log(studentData.toString());
      Popup.terminateLoading();
    } catch (e) {
      Popup.terminateLoading();
      Popup.general();
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: const Text('Update Student Result'),
            actions: const [],
          ),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// -------------------------------------- `usn`
                  CustomTextField(
                    usnController,
                    'usn',
                    1,
                    icon: Icons.numbers_rounded,
                    suffixIcon: Icons.search,
                    suffixFun: () => getStudentData(),
                  ),

                  /// -------------------------------------- `details TILE`
                  if (isDataFetched())
                    ResultDetailsTile(
                      studentData,
                      selectedSubject,
                      allSubjects,
                      selectedExamType,
                      marksController,
                    ),

                  MyElevatedBtn(
                    'Update Marks',
                    isDataFetched() ? updateMarks : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateMarks() async {
    final marks = marksController.text.trim();

    if (marks == '') {
      Popup.alert(
        'Oops!',
        'Hey, please fill out the marks before you submit.',
      );
      return;
    }

    if (double.tryParse(marks) == null || double.parse(marks) < 0) {
      Popup.alert(
        'Oops!',
        'Hey, please fill out valid marks.',
      );
      return;
    }

    if (selectedExamType() == CollegeData.exams[3] &&
        double.parse(marks) > 100) {
      Popup.alert(
        'Oops!',
        'Hey, SEE marks should be no greater that 100.',
      );
      return;
    } else if (selectedExamType() == CollegeData.exams[2] &&
        double.parse(marks) > 10) {
      Popup.alert(
        'Oops!',
        'Hey, Assignment marks should be no greater that 10.',
      );
      return;
    } else if (double.parse(marks) > 20) {
      Popup.alert(
        'Oops!',
        'Hey, CIE marks should be no greater that 20.',
      );
      return;
    }

    try {
      Popup.loading(label: 'Updating marks');

      // - - - - - - - - - - - - fetching old marks
      final allSubsSnap = await fire
          .collection(FireKeys.result)
          .doc('${studentData['usn']}-${studentData['sem']}')
          .get();

      Map<String, dynamic> allSubData =
          allSubsSnap.data() ?? {selectedSubject(): {}};

      // - - - - - - - - - - - - updating latest marks
      allSubData[selectedSubject()] = {};
      allSubData[selectedSubject()][selectedExamType()] =
          (double.tryParse(marks) ?? 0);

      await fire
          .collection(FireKeys.result)
          .doc('${studentData['usn']}-${studentData['sem']}')
          .set(allSubData);

      Popup.terminateLoading();
      marksController.clear();
      Popup.snackbar('Marks updated!', status: true);
    } on FirebaseException catch (e) {
      Popup.alert(e.code, e.message.toString());
    } catch (e) {
      Popup.terminateLoading();
      Popup.general();
      log(e.toString());
    }
  }
}
