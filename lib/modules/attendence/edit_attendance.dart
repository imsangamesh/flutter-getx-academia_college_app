import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/utils/popup.dart';

class EditAttendance extends StatelessWidget {
  EditAttendance(this.students, this.subCode, {super.key});

  final RxList<RxMap<String, dynamic>> students;
  final String subCode;

  final usnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Selector')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        itemCount: students.length,
        itemBuilder: (context, i) {
          final student = students[i];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(student['name']),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () => Get.to(
                () => EditStudentAttendance(student, subCode),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditStudentAttendance extends StatelessWidget {
  const EditStudentAttendance(this.student, this.subCode, {super.key});

  final RxMap<String, dynamic> student;
  final String subCode;

  void editAttendance(String docId, bool newVal) async {
    try {
      await fire
          .collection(FireKeys.students)
          .doc(student['usn'])
          .collection(subCode)
          .doc(docId)
          .update({'isPresent': newVal});
    } catch (e) {
      Popup.general();
    }
  }

  void deleteAttendance(String docId) async {
    try {
      await fire
          .collection(FireKeys.students)
          .doc(student['usn'])
          .collection(subCode)
          .doc(docId)
          .delete();
    } catch (e) {
      Popup.general();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${student['usn']}  |  $subCode')),
      body: StreamBuilder(
        stream: fire
            .collection(FireKeys.students)
            .doc(student['usn'])
            .collection(subCode)
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Popup.circleLoader();
          } else if (snapshot.hasData) {
            final studAtdSnap = snapshot.data;

            if (studAtdSnap == null || studAtdSnap.docs.isEmpty) {
              return Popup.nill(
                'Oops! No attendance records found\nfor this USN!',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              itemCount: studAtdSnap.docs.length,
              itemBuilder: (context, i) {
                final subAtdData = studAtdSnap.docs[i].data();
                final docId = studAtdSnap.docs[i].id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () => editAttendance(
                      docId,
                      !subAtdData['isPresent'],
                    ),
                    title: Text(
                      DateFormat('hh:mm, dd MMM yyy').format(
                        DateTime.parse(subAtdData['date']),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => Popup.confirm(
                            'Confirm?',
                            'Are you sure that you want to delete this attendance?',
                            yesFun: () => deleteAttendance(docId),
                          ),
                          color: AppColors.danger,
                          icon: const Icon(Icons.delete),
                        ),
                        Icon(
                          subAtdData['isPresent']
                              ? Icons.check_circle
                              : Icons.check_circle_outline_rounded,
                          color: subAtdData['isPresent']
                              ? AppColors.success
                              : AppColors.prim,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('...'));
          }
        },
      ),
    );
  }
}

/*

CheckboxListTile(
                    checkboxShape: const CircleBorder(),
                    activeColor: AppColors.success,
                    value: subAtdData['isPresent'],
                    onChanged: (newVal) => editAttendance(
                      studAtdSnap.docs[i].id,
                      newVal ?? false,
                    ),
                    title: Text(
                      DateFormat('hh:mm, dd MMM yyy').format(
                        DateTime.parse(subAtdData['date']),
                      ),
                    ),
                  ),
*/
