import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/core/widgets/my_dropdown_wrapper.dart';
import 'package:newbie/core/widgets/textfield_wrapper.dart';
import 'package:newbie/data/my_data.dart';

class UpdateCoreData extends StatelessWidget {
  UpdateCoreData({super.key});

  final textController = TextEditingController();
  final options = ['Students', 'Faculties', 'Admins', 'Dept Sem Subjects'];
  final selectedOption = 'Students'.obs;

  /// -------------------------------------- `SUBMIT & UPDATE DATA`
  Future<void> updateDataToFirestore() async {
    if (textController.text.trim() == '') {
      Popup.alert(
        'Oops!',
        'Please input valid JSON data before proceeding',
      );
      return;
    }

    try {
      Popup.loading(label: 'loading');

      // final inputJSONData = selectedOption.value == 'Students'
      //     ? MyData.studentsJSON
      //     : selectedOption.value == 'Faculties'
      //         ? MyData.facultyJSON
      //         : selectedOption.value == 'Admins'
      //             ? MyData.adminJSON
      //             : MyData.subjectsJSON;

      final inputJSONData = json.decode(textController.text);
      WriteBatch studentsBatch = fire.batch(); // create BATCH

      for (var each in inputJSONData.entries) {
        final clxn = selectedOption.value == 'Students'
            ? FireKeys.students
            : selectedOption.value == 'Faculties'
                ? FireKeys.faculties
                : selectedOption.value == 'Admins'
                    ? FireKeys.admins
                    : FireKeys.deptSemSubjects;

        final docRef = fire.collection(clxn).doc(each.key);
        studentsBatch.set(docRef, each.value); // set data into BATCH
      }

      await studentsBatch.commit(); // commit to BATCH

      Popup.terminateLoading();
      Popup.snackbar('Data Upload successful!', status: true);
      textController.clear();
    } on FirebaseException catch (error) {
      Popup.terminateLoading();
      Popup.alert(error.code, error.message.toString());
    } catch (e) {
      Popup.terminateLoading();
      Popup.general();
    }
  }

  uploadResultData() async {
    try {
      Popup.loading(label: 'loading');

      for (var eachStud in MyData.resultJSON.entries) {
        for (var eachSem in eachStud.value.entries) {
          await fire
              .collection(FireKeys.result)
              .doc('${eachStud.key}-${eachSem.key}')
              .set(eachSem.value);
        }
      }

      Popup.terminateLoading();
      Popup.snackbar('Result Data Upload successful!', status: true);
    } on FirebaseException catch (error) {
      Popup.terminateLoading();
      Popup.alert(error.code, error.message.toString());
    } catch (e) {
      Popup.terminateLoading();
      Popup.general();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update JSON Data'),
        actions: [
          IconButton(
            onPressed: uploadResultData,
            icon: const Icon(Icons.circle),
          )
        ],
      ),
      body: Obx(
        () => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),

              /// ------------------------------ `BODY`
              child: SizedBox(
                height: size.height - 80 - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// ------------------------------ `SELECTOR DROP DOWN`
                    MyDropDownWrapper(
                      DropdownButton(
                        dropdownColor: AppColors.listTile,
                        underline: MyDropDownWrapper.transparentDivider,
                        isExpanded: true,
                        iconSize: 30,
                        icon: const Icon(Icons.arrow_drop_down),
                        value: selectedOption.value,
                        items: options
                            .map((String each) => DropdownMenuItem(
                                  value: each,
                                  child: Text(
                                    ' $each',
                                    style: selectedOption() == each
                                        ? AppTStyles.subHeading
                                        : null,
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newValue) =>
                            selectedOption(newValue!),
                      ),
                    ),

                    /// ------------------------------ `INPUT FIELD`
                    Expanded(
                      child: TextFieldWrapper(
                        TextField(
                          controller: textController,
                          expands: true,
                          maxLines: null,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: '$selectedOption Json Data',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    /// ------------------------------ `BODY`
                    MyElevatedBtn(
                      'Save And Update',
                      () => Popup.confirm(
                        'Confirm?',
                        'Are you sure you want to save and update the data?',
                        yesFun: () => updateDataToFirestore(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
