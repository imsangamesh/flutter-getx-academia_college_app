import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/utils/popup.dart';

class TakeStudentAttendance extends StatelessWidget {
  TakeStudentAttendance(this.students, this.subCode, {super.key});
  //
  final RxList<RxMap<String, dynamic>> students;
  final String subCode;
  final selectAll = false.obs;

  toggleSelectAll(bool? newVal) {
    selectAll.value = newVal ?? false; // changing value
    for (var each in students) {
      each['isPresent'] = newVal == true ? true : false;
    }
  }

  /// -------------------------------------------- `SUBMIT`
  submitAttendance() async {
    try {
      Popup.loading(label: 'Updating attendance');
      final attendanceDate = DateTime.now().toIso8601String();

      for (var eachStud in students) {
        final attendanceData = {
          'date': attendanceDate,
          'isPresent': eachStud['isPresent'],
        };

        await fire
            .collection(FireKeys.students)
            .doc(eachStud['usn'])
            .collection(subCode)
            .doc()
            .set(attendanceData);
      }

      Popup.terminateLoading();
      Get.back();

      Popup.snackbar('Attendance updated!', status: true);
    } catch (e) {
      log(e.toString());
      Popup.terminateLoading();
      Popup.general();
    }
  }

  confirmSubmitAttendance() => Popup.confirm(
        'Confirm?',
        'Are you sure to submit the attendance?',
        yesFun: submitAttendance,
      );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("$subCode  |  Attendance"),
          actions: [
            IconButton(
              icon: const Icon(Icons.done_outline_rounded),
              onPressed: () => Popup.confirm(
                'Confirm?',
                'Are you sure you want to submit the classroom attendance?',
                yesFun: submitAttendance,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              /// ----------------- `SELECT ALL BUTTON`
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: CheckboxListTile(
                  checkboxShape: const CircleBorder(),
                  activeColor: AppColors.prim,
                  title: Text(selectAll.value ? 'Deselect All' : 'Select All'),
                  tileColor: AppColors.listTile,
                  value: selectAll.value,
                  onChanged: toggleSelectAll,
                ),
              ),
              const Divider(),

              /// ----------------- `STUDENTS LIST`
              ...students
                  .map(
                    (each) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CheckboxListTile(
                        checkboxShape: const CircleBorder(),
                        activeColor: AppColors.success,
                        title: Text(
                          each['usn'],
                          style: TextStyle(color: AppColors.normal),
                        ),
                        subtitle: Text(
                          each['name'],
                          style: TextStyle(color: AppColors.themeGrey),
                        ),
                        tileColor: AppColors.listTile,
                        value: each['isPresent'],
                        onChanged: (val) => each['isPresent'] = val ?? false,
                      ),
                    ),
                  )
                  .toList(),
            ]),
          ),
        ),
      ),
    );
  }
}
