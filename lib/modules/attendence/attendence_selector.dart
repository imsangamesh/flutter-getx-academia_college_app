import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/attendence/edit_attendance.dart';
import 'package:newbie/modules/attendence/take_student_attendence.dart';

import '../../core/widgets/my_buttons.dart';
import '../../core/widgets/my_dropdown_wrapper.dart';

class AttendanceSelector extends StatelessWidget {
  AttendanceSelector({super.key});

  final selectedDept = CollegeData.fullDepts.first.obs;
  final selectedSem = '7'.obs;
  final selectedDiv = CollegeData.divisions.first.obs;

  final areSubjectsFetched = false.obs;

  final selectedSubCode = ''.obs;
  final subjectCodes = RxList([]);

  final RxList<RxMap<String, dynamic>> students = RxList([]);

  /// - - - - - - - - - - - - - - - - - - - - `fetch SUBJECTS`
  Future<void> fetchSubjects() async {
    final dept = MyHelper.l2sDept(selectedDept());

    try {
      Popup.loading(label: 'fetching dept subjects');

      final snapshot = await fire
          .collection(FireKeys.deptSemSubjects)
          .doc('$dept-$selectedSem')
          .get();

      final docData = snapshot.data();
      if (docData == null || docData['subjects'].entries.isEmpty) {
        Popup.terminateLoading();
        Popup.alert(
          'Oops!',
          'The subjects for the respective semester are not found',
        );
        return;
      }

      final subs = docData['subjects'];
      subjectCodes.clear();

      for (var eachMap in subs.entries) {
        subjectCodes.add(eachMap.key);
      }

      selectedSubCode(subjectCodes[0]);
      areSubjectsFetched(true);

      Popup.terminateLoading();
    } catch (e) {
      Popup.terminateLoading();
      Popup.general();
    }
  }

  /// - - - - - - - - - - - - - - - - - - - - `fetch STUDENTS for selected_SUB`
  fetchStudentsAndProceed(String mode) async {
    final dept = MyHelper.l2sDept(selectedDept());

    try {
      Popup.loading(label: 'fetching students...');

      final studSnapshot = await fire.collection(FireKeys.students).get();
      final studentList = studSnapshot.docs
          .map((e) => e.data())
          .where((studMap) =>
              studMap['dept'] == dept &&
              studMap['sem'] == selectedSem() &&
              studMap['div'] == selectedDiv())
          .toList();

      if (studentList.isEmpty) {
        Popup.terminateLoading();
        Popup.alert(
          'Oops!',
          'No students found for the respective dept, semester and div...',
        );
        return;
      }

      students.clear();
      for (var studentMap in studentList) {
        final studMap = RxMap<String, dynamic>({});

        studMap['usn'] = studentMap['usn']; // string
        studMap['name'] = studentMap['name']; // string
        studMap['isPresent'] = false; // boolean

        students.add(studMap);
      }

      Popup.terminateLoading();
      if (mode == 'new') {
        await Get.to(() => TakeStudentAttendance(students, selectedSubCode()));
      } else {
        await Get.to(() => EditAttendance(students, selectedSubCode()));
      }
    } catch (e) {
      Popup.terminateLoading();
      Popup.general();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(
        () => Scaffold(
          appBar: AppBar(title: const Text('Attendance Selector')),
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
                      dropdownColor: AppColors.listTile,
                      underline: MyDropDownWrapper.transparentDivider,
                      isExpanded: true,
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: selectedDept(),
                      items: CollegeData.fullDepts
                          .map((String each) => DropdownMenuItem(
                                value: each,
                                child: Text(
                                  '  $each',
                                  style: selectedDept() == each
                                      ? AppTStyles.subHeading
                                      : null,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) => selectedDept(newValue!),
                    ),
                  ),

                  /// -------------------------------------- `semester`
                  MyDropDownWrapper(
                    DropdownButton(
                      dropdownColor: AppColors.listTile,
                      underline: MyDropDownWrapper.transparentDivider,
                      isExpanded: true,
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: selectedSem(),
                      items: CollegeData.semesters
                          .map((String each) => DropdownMenuItem(
                                value: each,
                                child: Text(
                                  '  $each semester',
                                  style: selectedSem() == each
                                      ? AppTStyles.subHeading
                                      : null,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) => selectedSem(newValue!),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MyOutlinedBtn(
                      'Fetch Subjects',
                      fetchSubjects,
                      radius: 10,
                    ),
                  ),

                  /// -------------------------------------- `selected SUBJECT`
                  if (areSubjectsFetched())
                    MyDropDownWrapper(
                      DropdownButton(
                        dropdownColor: AppColors.listTile,
                        underline: MyDropDownWrapper.transparentDivider,
                        isExpanded: true,
                        iconSize: 30,
                        icon: const Icon(Icons.arrow_drop_down),
                        value: selectedSubCode(),
                        items: subjectCodes
                            .map((e) => e.toString())
                            .map((String each) => DropdownMenuItem(
                                  value: each,
                                  child: Text(
                                    '  $each',
                                    style: selectedSubCode() == each
                                        ? AppTStyles.subHeading
                                        : null,
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newValue) =>
                            selectedSubCode(newValue!),
                      ),
                    ),

                  /// -------------------------------------- `division`
                  if (areSubjectsFetched())
                    MyDropDownWrapper(
                      DropdownButton(
                        dropdownColor: AppColors.listTile,
                        underline: MyDropDownWrapper.transparentDivider,
                        isExpanded: true,
                        iconSize: 30,
                        icon: const Icon(Icons.arrow_drop_down),
                        value: selectedDiv(),
                        items: CollegeData.divisions
                            .map((String each) => DropdownMenuItem(
                                  value: each,
                                  child: Text(
                                    '  $each division',
                                    style: selectedDiv() == each
                                        ? AppTStyles.subHeading
                                        : null,
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newValue) => selectedDiv(newValue!),
                      ),
                    ),

                  // --------------------------------- TAKE or EDIT ATTENDANCE
                  if (areSubjectsFetched())
                    Row(
                      children: [
                        Expanded(
                          child: MyOutlinedBtn(
                            'View & Edit',
                            () => fetchStudentsAndProceed('edit'),
                            radius: 10,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyElevatedBtn(
                            'New',
                            () => fetchStudentsAndProceed('new'),
                            radius: 10,
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
