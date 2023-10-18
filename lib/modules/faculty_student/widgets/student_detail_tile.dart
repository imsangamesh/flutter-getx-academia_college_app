import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helpers/my_helper.dart';
import '../../../core/themes/my_colors.dart';
import '../../../core/themes/my_textstyles.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/my_dropdown_wrapper.dart';

class StudentDetailTile extends StatelessWidget {
  const StudentDetailTile(
    this.studentData,
    this.selectedSubject,
    this.allSubjects,
    this.selectedExam,
    this.cieSelectors,
    this.marksController, {
    super.key,
  });

  final Map<dynamic, dynamic> studentData;

  final RxList allSubjects;
  final RxString selectedSubject;

  final List<String> cieSelectors;
  final RxString selectedExam;

  final TextEditingController marksController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 2),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeColors.shade15,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -------------------------------------- `Name`
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(
              '${studentData['name']!} | ${studentData['usn']!}',
              style: MyTStyles.title,
            ),
          ),

          /// -------------------------------------- `Details`
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
            child: Row(
              children: [
                container('${studentData['dept']!}'),
                container('${studentData['sem']!} sem'),
                container('${studentData['div']!} div'),
              ],
            ),
          ),

          /// -------------------------------------- `Subjects`
          const SizedBox(height: 15),
          MyDropDownWrapper(
            DropdownButton(
              dropdownColor: ThemeColors.listTile,
              underline: MyDropDownWrapper.transDivider,
              isExpanded: true,
              iconSize: 30,
              icon: const Icon(Icons.arrow_drop_down),
              value: selectedSubject(),
              items: allSubjects
                  .map((e) => e.toString())
                  .map((String each) => DropdownMenuItem(
                        value: each,
                        child: Text(
                          '  $each',
                          style: selectedSubject() == each
                              ? TextStyle(color: ThemeColors.darkPrim)
                              : null,
                        ),
                      ))
                  .toList(),
              onChanged: (String? newValue) => selectedSubject(newValue!),
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
                      value: selectedExam(),
                      items: cieSelectors
                          .map((String each) => DropdownMenuItem(
                                value: each,
                                child: Text(
                                  '  $each',
                                  style: selectedExam() == each
                                      ? TextStyle(color: ThemeColors.darkPrim)
                                      : null,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) => selectedExam(newValue!),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                /// -------------------------------------- `credits`
                Expanded(
                  child: CustomTextField(
                    marksController,
                    'marks',
                    1,
                    icon: Icons.numbers_rounded,
                    radius: 10,
                    inputType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),

          /// -------------------------------------- `CIE selector`
        ],
      ),
    );
  }

  Container container(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: ThemeColors.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label, style: MyTStyles.body),
    );
  }
}
