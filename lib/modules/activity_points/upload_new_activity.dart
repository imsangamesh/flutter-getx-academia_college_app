import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/file_controller.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/models/activity_model.dart';

import '../../core/helpers/my_helper.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/my_buttons.dart';

class AddNewActivity extends StatelessWidget {
  AddNewActivity({super.key});

  // TODO: Remove these hardcoded
  final descController = TextEditingController(text: Dummy.lorem);
  final hoursController = TextEditingController(text: '40');

  final Rx<File> file = File('').obs;
  final RxMap<String, dynamic> fileDetails = RxMap();

  pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      Popup.snackbar('you didn\'t pick any files', status: false);
      file.value = File('');
      return;
    }

    file(File(result.files.first.path!));
  }

  Future<bool> uploadFile() async {
    final fileData = await FileController.uploadSingle(file.value);
    if (fileData == null) return false;

    fileDetails(fileData);
    return true;
  }

  /// - - - - - - - - - - - - - - - - - - - `UPLOAD ACTIVITY`
  uploadActivity() async {
    if (hoursController.text.trim() == '' || descController.text.trim() == '') {
      Popup.alert(
        'Oops!',
        'Please make sure that you have filled hours and description before submitting.',
      );
      return;
    }

    if (file.value.path == '') {
      Popup.snackbar('Please pick file', status: false);
      return;
    }

    try {
      if (!await uploadFile()) {
        Popup.general();
        return;
      }

      Popup.loading(label: 'Updating Activity');
      // TODO: final usn = AppData.fetchData()['usn'];
      const usn = '2BA20CS074';

      final studentData = await MyHelper.fetchStudentMap();
      studentData['pendingActivities'] += 1;

      final activity = Activity(
        id: timeId,
        description: descController.text.trim(),
        fileDetails: fileDetails,
        hours: int.parse(hoursController.text.trim()),
        status: 'pending',
        points: int.parse(hoursController.text.trim()) / 4,
      );

      // updating `pending activities`
      await fire.collection(FireKeys.students).doc(usn).set(studentData);

      // updating `activity`
      await fire
          .collection(FireKeys.students)
          .doc(usn)
          .collection(FireKeys.activities)
          .doc(activity.id)
          .set(activity.toMap());

      Get.close(2);
      Popup.snackbar('Activity Upload successful!', status: true);
    } catch (e) {
      Get.back();
      log(e.toString());
      Popup.alert('Oops!', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Upload New Activity')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(
              () => Column(
                children: [
                  SizedBox(
                    width: MyHelper.scrSize(context).width,
                    height: 63,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// -------------------------------------- `credits`
                        Expanded(
                          child: CustomTextField(
                            hoursController,
                            'hours',
                            1,
                            icon: Icons.alarm,
                            radius: 10,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 15),

                        /// -------------------------------------- `Pick files`
                        SizedBox(
                          height: 46,
                          child: MyOutlinedBtn(
                            file.value.path == '' ? 'Pick File' : 'Picked',
                            () => pickFile(),
                            icon: file.value.path == ''
                                ? Icons.attach_file
                                : Icons.done,
                            radius: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// --------------------------------------- `description`
                  CustomTextField(
                    descController,
                    'description',
                    20,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: MyElevatedBtn('Upload', () => uploadActivity()),
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
