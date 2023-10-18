import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/data/my_data.dart';

import '../../../core/constants/my_constants.dart';
import '../../../core/themes/my_colors.dart';
import '../../../core/utilities/utils.dart';
import '../../../core/widgets/my_buttons.dart';
import '../../../core/widgets/my_dropdown_wrapper.dart';
import '../student_attendence.dart';

class AttendenceSelector extends StatelessWidget {
  AttendenceSelector({super.key});

  final selectedDept = MyData.fullDepts.first.obs;
  final selectedSem = MyData.semesters.first.obs;
  final selectedDiv = MyData.divisions.first.obs;

  final areSubjectsFetched = false.obs;

  final selectedSub = ''.obs;
  final allSubjects = RxList([]);

  final RxList<RxMap<String, dynamic>> students = RxList([]);

  /// - - - - - - - - - - - - - - - - - - - - `fetch student SUBJECTS`
  Future<void> fetchSubjects() async {
    final dept = MyHelper.deptToKey(selectedDept());

    try {
      Utils.progressIndctr(label: 'fetching dept subjects...');

      final snapshot = await fire.collection('dept_sem_data').get();

      final subjectsData = snapshot.docs
          .map((e) => e.data())
          .where((dataMap) =>
              dataMap['dept'] == dept &&
              dataMap['sem'] == selectedSem() &&
              dataMap['div'] == selectedDiv())
          .toList();

      if (subjectsData.isEmpty) {
        Get.back();
        Utils.showAlert(
          'Oops!',
          'The subjects for the respective semester are not found',
        );
        return;
      }

      allSubjects([]);
      for (var subMap in subjectsData) {
        allSubjects.add(subMap['sub']);
      }

      selectedSub(allSubjects[0]);
      areSubjectsFetched(true);

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
          appBar: AppBar(title: const Text('Attendence Selector')),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// -------------------------------------- `department`
                  MyDropDownWrapper(
                    DropdownButton(
                      dropdownColor: ThemeColors.listTile,
                      underline: MyDropDownWrapper.transDivider,
                      isExpanded: true,
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: selectedDept(),
                      items: MyData.fullDepts
                          .map((String each) => DropdownMenuItem(
                                value: each,
                                child: Text(
                                  '  $each',
                                  style: selectedDept() == each
                                      ? TextStyle(color: ThemeColors.darkPrim)
                                      : null,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) => selectedDept(newValue!),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// -------------------------------------- `semester`
                  MyDropDownWrapper(
                    DropdownButton(
                      dropdownColor: ThemeColors.listTile,
                      underline: MyDropDownWrapper.transDivider,
                      isExpanded: true,
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: selectedSem(),
                      items: MyData.semesters
                          .map((String each) => DropdownMenuItem(
                                value: each,
                                child: Text(
                                  '  $each semester',
                                  style: selectedSem() == each
                                      ? TextStyle(color: ThemeColors.darkPrim)
                                      : null,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) => selectedSem(newValue!),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// -------------------------------------- `division`
                  SizedBox(
                    width: MyHelper.scrSize(context).width,
                    height: 63,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: MyDropDownWrapper(
                            DropdownButton(
                              dropdownColor: ThemeColors.listTile,
                              underline: MyDropDownWrapper.transDivider,
                              isExpanded: true,
                              iconSize: 30,
                              icon: const Icon(Icons.arrow_drop_down),
                              value: selectedDiv(),
                              items: MyData.divisions
                                  .map((String each) => DropdownMenuItem(
                                        value: each,
                                        child: Text(
                                          '  $each division',
                                          style: selectedDiv() == each
                                              ? TextStyle(
                                                  color: ThemeColors.darkPrim)
                                              : null,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) =>
                                  selectedDiv(newValue!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),

                        /// -------------------------------------- `fetch SUBJECTS`
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: MyOutlinedBtn(
                              'Fetch Subjects',
                              fetchSubjects,
                              radius: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// -------------------------------------- `selected SUBJECT`
                  if (areSubjectsFetched())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: MyDropDownWrapper(
                        DropdownButton(
                          dropdownColor: ThemeColors.listTile,
                          underline: MyDropDownWrapper.transDivider,
                          isExpanded: true,
                          iconSize: 30,
                          icon: const Icon(Icons.arrow_drop_down),
                          value: selectedSub(),
                          items: allSubjects
                              .map((e) => e.toString())
                              .map((String each) => DropdownMenuItem(
                                    value: each,
                                    child: Text(
                                      '  $each',
                                      style: selectedSub() == each
                                          ? TextStyle(
                                              color: ThemeColors.darkPrim)
                                          : null,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) =>
                              selectedSub(newValue!),
                        ),
                      ),
                    ),

                  // --------------------------------- submit ---------------
                  MyElevatedBtn(
                    'Take Attendence',
                    areSubjectsFetched()
                        ? () => fetchStudentsAndProceed()
                        : null,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  fetchStudentsAndProceed() async {
    final dept = MyHelper.deptToKey(selectedDept());

    try {
      Utils.progressIndctr(label: 'fetching students...');

      final snapshot = await fire.collection('students').get();
      final studentData = snapshot.docs
          .map((e) => e.data())
          .where((dataMap) =>
              dataMap['dept'] == dept &&
              dataMap['sem'] == selectedSem() &&
              dataMap['div'] == selectedDiv())
          .toList();

      log(studentData.toString());
      if (studentData.isEmpty) {
        Get.back();
        Utils.showAlert(
          'Oops!',
          'No students found for the respective semester.',
        );
        return;
      }

      students([]);
      for (var stdMap in studentData) {
        stdMap['atd'] = false.obs;
        students.add(RxMap(stdMap));
      }

      Get.back();
      log(students.toString());
      Get.to(() => StudentAttendence(students, selectedSub()));
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
  }
}
