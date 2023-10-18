import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/utilities/utils.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/faculty_student/widgets/student_detail_tile.dart';

import '../../core/constants/my_constants.dart';
import '../../core/widgets/custom_textfield.dart';

class StudentResultUpdatePage extends StatelessWidget {
  StudentResultUpdatePage({super.key});

  final usnController = TextEditingController();
  final studentData = RxMap({});
  final isDataFetched = false.obs;

  final selectedSubject = ''.obs;
  final allSubjects = RxList([]);

  final cieSelectors = ['CIE 1', 'CIE 2', 'CIE 3', 'Assignment'];
  final selectedExam = 'CIE 1'.obs;

  final marksController = TextEditingController();

  /// - - - - - - - - - - - - - - - - - - - - `fetch STUDENT data`
  Future<void> getStudentData() async {
    final usn = usnController.text.trim().toUpperCase();

    Utils.progressIndctr(label: 'fetching student data...');
    try {
      final snapshot = await fire.collection('students').get();

      final data = snapshot.docs
          .map((e) => e.data())
          .firstWhere((element) => element['usn'] == usn);

      studentData(data);
      log(studentData.toString());
      getStudentSubjects();
      Get.back();
    } catch (e) {
      Get.back();
      Utils.showAlert('Oops!', 'no data found with the provided USN');
    }
  }

  /// - - - - - - - - - - - - - - - - - - - - `fetch student SUBJECTS`
  Future<void> getStudentSubjects() async {
    try {
      final snapshot = await fire.collection('dept_sem_data').get();

      Utils.progressIndctr(label: 'fetching student subjects...');
      final subjectsData = snapshot.docs
          .map((e) => e.data())
          .where((element) =>
              element['dept'] == studentData['dept'] &&
              element['sem'] == studentData['sem'] &&
              element['div'] == studentData['div'])
          .toList();

      if (subjectsData.isEmpty) {
        Utils.showAlert(
          'Oops!',
          'The subjects for the respective semester are not found',
        );
        Get.back();
        return;
      }

      allSubjects([]);
      for (var subMap in subjectsData) {
        allSubjects.add(subMap['sub']);
      }

      selectedSubject(allSubjects[0]);
      isDataFetched(true);
      log(studentData.toString());
      Get.back();
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: const Text('Student Result Update'),
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
                    suffixIcon: Icons.send_rounded,
                    suffixFun: getStudentData,
                  ),

                  /// -------------------------------------- `details`
                  if (isDataFetched())
                    StudentDetailTile(
                      studentData,
                      selectedSubject,
                      allSubjects,
                      selectedExam,
                      cieSelectors,
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

  updateData() async {
    try {
      fire
          .collection('results')
          .doc(studentData['usn'])
          .collection(studentData['sem'])
          .doc(selectedSubject())
          .set({
        'CIE 1': '18',
        'CIE 2': '19',
        'Assignment': '8',
      });

      Utils.showSnackBar('Marks updated!');
    } catch (e) {
      Utils.normalDialog();
    }
  }

  updateMarks() async {
    try {
      // - - - - - - - - - - - - fetching old marks
      final previousMarksSnap = await fire
          .collection('results')
          .doc(studentData['usn'])
          .collection(studentData['sem'])
          .doc(selectedSubject())
          .get();

      Map<String, dynamic> previousMarksData = {};
      if (previousMarksSnap.exists && previousMarksSnap.data() != null) {
        previousMarksData = previousMarksSnap.data()!;
      }

      // - - - - - - - - - - - - updating latest marks
      previousMarksData[selectedExam()] =
          marksController.text.trim().toString();

      fire
          .collection('results')
          .doc(studentData['usn'])
          .collection(studentData['sem'])
          .doc(selectedSubject())
          .set(previousMarksData);

      Utils.showSnackBar('Marks updated!');
    } catch (e) {
      Utils.normalDialog();
    }
  }
}
