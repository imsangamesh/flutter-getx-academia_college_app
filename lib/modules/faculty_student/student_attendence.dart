import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/utilities/utils.dart';

import '../../core/constants/my_constants.dart';
import '../../core/themes/my_colors.dart';

class StudentAttendence extends StatelessWidget {
  const StudentAttendence(this.students, this.subject, {super.key});
  //
  final RxList<RxMap<String, dynamic>> students;
  final String subject;

  submitAttendence() async {
    try {
      Utils.progressIndctr(label: 'updating...');

      for (var std in students) {
        log(std.toString());

        final atdData = {
          'subject': subject,
          'date': DateTime.now().toIso8601String(),
          'atd': std['atd'].value,
        };

        fire
            .collection('students')
            .doc(std['usn'])
            .collection('attendence')
            .doc(atdData.values.join('~~~'))
            .set(atdData);
      }

      Get.back();
      Utils.showSnackBar('Attendence updated!');
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
  }

  confirmSubmitAttendence() => Utils.confirmDialogBox(
        'Confirm?',
        'Are you sure to submit the attendence?',
        yesFun: submitAttendence,
      );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Student Attendence"),
          actions: [
            IconButton(
              onPressed: () => confirmSubmitAttendence(),
              icon: const Icon(Icons.done_outline_rounded),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: students
                  .map(
                    (element) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CheckboxListTile(
                        title: Text(element['name']),
                        tileColor: ThemeColors.shade20,
                        value: element['atd'](),
                        onChanged: (val) => element['atd'].value = val ?? false,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
