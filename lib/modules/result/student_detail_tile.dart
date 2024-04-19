import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/data/college_data.dart';

import '../../core/helpers/my_helper.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/my_dropdown_wrapper.dart';

class ResultDetailsTile extends StatelessWidget {
  const ResultDetailsTile(
    this.studentData,
    this.selectedSubject,
    this.allSubjects,
    this.selectedExamType,
    this.marksController, {
    super.key,
  });

  final Map<dynamic, dynamic> studentData;

  final RxList<String> allSubjects;
  final RxString selectedSubject;

  final RxString selectedExamType;

  final TextEditingController marksController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 2),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.listTile.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -------------------------------------- `Name`
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(
              '${studentData['name']!}\n${studentData['usn']!}',
              style: AppTStyles.subHeading,
            ),
          ),

          /// -------------------------------------- `Details`
          const Divider(indent: 0, endIndent: 0),
          Row(
            children: [
              MyChip('${studentData['dept']!}', mr: 10),
              MyChip('${studentData['sem']!} sem', mr: 10),
              MyChip('${studentData['div']!} div', mr: 10),
            ],
          ),
          const Divider(indent: 0, endIndent: 0),

          /// -------------------------------------- `Subject Selector`
          MyDropDownWrapper(
            DropdownButton(
              dropdownColor: AppColors.listTile,
              underline: MyDropDownWrapper.transparentDivider,
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
                              ? AppTStyles.subHeading
                              : null,
                        ),
                      ))
                  .toList(),
              onChanged: (String? newValue) => selectedSubject(newValue!),
            ),
          ),

          /// ------------------------- `CIEs or SEE or ASS Selector`
          SizedBox(
            width: MyHelper.scrSize(context).width,
            height: 63,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: MyDropDownWrapper(
                    DropdownButton(
                      dropdownColor: AppColors.listTile,
                      underline: MyDropDownWrapper.transparentDivider,
                      isExpanded: true,
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: selectedExamType(),
                      items: CollegeData.exams
                          .map((String each) => DropdownMenuItem(
                                value: each,
                                child: Text(
                                  '  $each',
                                  style: selectedExamType() == each
                                      ? AppTStyles.subHeading
                                      : null,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) =>
                          selectedExamType(newValue!),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                /// -------------------------------------- `marks`
                Expanded(
                  flex: 7,
                  child: CustomTextField(
                    marksController,
                    'marks',
                    1,
                    icon: Icons.numbers_rounded,
                    radius: 10,
                    inputType: TextInputType.number,
                    maxLength: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
