import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/my_constants.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/data/my_data.dart';
import 'package:newbie/modules/dept_sem_adder/add_admin_json.dart';
import 'package:newbie/modules/dept_sem_adder/add_faculty_json.dart';
import 'package:newbie/modules/dept_sem_adder/add_student_json.dart';
import 'package:newbie/modules/dept_sem_adder/faculty_fetcher.dart';

import '../../core/themes/my_colors.dart';
import '../../core/utilities/utils.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/my_dropdown_wrapper.dart';
import '../../models/dept_sem_div_model.dart';

class AddDeptAndSemester extends StatefulWidget {
  const AddDeptAndSemester({super.key});

  @override
  State<AddDeptAndSemester> createState() => _AddDeptAndSemesterState();
}

class _AddDeptAndSemesterState extends State<AddDeptAndSemester> {
  final selectedDept = MyData.fullDepts.first.obs;
  final selectedSem = MyData.semesters.first.obs;
  final selectedDiv = MyData.divisions.first.obs;

  final subjectController = TextEditingController();
  final creditController = TextEditingController();

  final facultyList = [''].obs;
  final selectedFaculty = ''.obs;

  @override
  void initState() {
    getFaculties();
    super.initState();
  }

  getFaculties() async {
    final dept = MyHelper.deptToKey(selectedDept());
    final snapshot = await fire.collection('faculties').get();

    final facData = snapshot.docs
        .where((element) => element.data()['dept'].toString() == dept)
        .map((each) => each.data()['name'].toString())
        .toList();
    facultyList(facData);

    log(facultyList.toString());
    selectedFaculty(facultyList[0]);
  }

  Future<void> updateDataToFirestore() async {
    final dept = MyHelper.deptToKey(selectedDept.trim());
    final sem = selectedSem.trim();
    final div = selectedDiv.trim();
    final sub = subjectController.text.trim();
    final credits = creditController.text.trim();

    final deptSemData = DeptSemDivModel(
      dept: dept,
      sem: sem,
      div: div,
      sub: sub,
      credits: credits,
      faculty: selectedFaculty(),
    );

    try {
      fire
          .collection('dept_sem_data')
          .doc('$dept~~~$sem~~~$div~~~$sub')
          .set(deptSemData.toMap());

      Utils.showSnackBar('Subject added!', status: true);
    } catch (e) {
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
            title: const Text('Add Dept & Sem'),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () => Get.to(() => AddAdminJson()),
                icon: const Icon(Icons.account_circle_rounded),
              ),
              IconButton(
                onPressed: () => Get.to(() => AddStudentJson()),
                icon: const Icon(Icons.school_rounded),
              ),
              IconButton(
                onPressed: () => Get.to(() => AddFacultyJson()),
                icon: const Icon(Icons.contacts),
              ),
            ],
          ),
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
                      onChanged: (String? newValue) {
                        selectedDept(newValue!);
                        getFaculties();
                      },
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
                        MyDropDownWrapper(
                          DropdownButton(
                            dropdownColor: ThemeColors.listTile,
                            underline: MyDropDownWrapper.transDivider,
                            isExpanded: false,
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
                        const SizedBox(width: 15),

                        /// -------------------------------------- `credits`
                        Expanded(
                          child: CustomTextField(
                            creditController,
                            'credits',
                            1,
                            icon: Icons.numbers_rounded,
                            radius: 10,
                            inputType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// -------------------------------------- `faculties`
                  SizedBox(
                    child: FacultyFetcherDropdown(facultyList, selectedFaculty),
                  ),
                  const SizedBox(height: 15),

                  /// -------------------------------------- `subject`
                  CustomTextField(
                    subjectController,
                    'subject name',
                    1,
                    icon: Icons.short_text,
                  ),

                  // --------------------------------- submit ---------------
                  MyElevatedBtn('Submit', () => updateDataToFirestore())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
