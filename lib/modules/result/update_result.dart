import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/custom_textfield.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/data/college_data.dart';

class UpdateResultScreen extends StatelessWidget {
  UpdateResultScreen({
    super.key,
    required this.subject,
    required this.sem,
    required this.examType,
    required this.usnList,
  });

  final String subject;
  final String sem;
  final String examType;
  final List<String> usnList;
  final marksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('$sem sem  -  $subject  -  $examType'),
          actions: const [],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          itemCount: usnList.length,
          itemBuilder: (_, i) {
            final usn = usnList[i];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                onTap: () => openBottomSheet(context, usn),
                title: Text(usn),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
            );
          },
        ),
      ),
    );
  }

  openBottomSheet(BuildContext context, String usn) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Container(
          height: 500,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              CustomTextField(
                marksController,
                'Marks',
                icon: Icons.numbers_rounded,
                radius: 10,
                inputType: TextInputType.number,
                maxLength: 4,
              ),
              SizedBox(
                width: double.infinity,
                child: MyOutlinedBtn('Update Marks', () => updateMarks(usn)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateMarks(String usn) async {
    final marks = marksController.text.trim();

    if (marks == '') {
      Popup.alert(
        'Oops!',
        'Please fill out the marks before you submit.',
      );
      return;
    }

    if (double.tryParse(marks) == null || double.parse(marks) < 0) {
      Popup.alert(
        'Oops!',
        'Please fill out valid marks.',
      );
      return;
    }

    if (examType == CollegeData.exams[3] && double.parse(marks) > 100) {
      Popup.alert(
        'Oops!',
        'SEE marks should be no greater that 100.',
      );
      return;
    } else if (examType == CollegeData.exams[2] && double.parse(marks) > 10) {
      Popup.alert(
        'Oops!',
        'Assignment marks should be no greater that 10.',
      );
      return;
    } else if (double.parse(marks) > 20) {
      Popup.alert(
        'Oops!',
        'CIE marks should be no greater that 20.',
      );
      return;
    }

    try {
      Popup.loading(label: 'Updating marks');

      // - - - - - - - - - - - - fetching old marks
      final allSubsSnap =
          await fire.collection(FireKeys.result).doc('$usn-$sem').get();

      Map<String, dynamic> allSubData = allSubsSnap.data() ?? {subject: {}};

      // - - - - - - - - - - - - updating latest marks
      allSubData[subject] = {};
      allSubData[subject][examType] = (double.tryParse(marks) ?? 0);

      await fire.collection(FireKeys.result).doc('$usn-$sem').set(allSubData);

      Popup.terminateLoading();
      Get.back();
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
