import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/upload_controller.dart';
import '../../core/constants/my_constants.dart';
import '../../core/helpers/my_helper.dart';
import '../../core/utilities/utils.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/my_buttons.dart';

class UploadStudentActivity extends StatelessWidget {
  UploadStudentActivity({super.key});

  final descController = TextEditingController();
  final hoursController = TextEditingController();

  final RxList<PlatformFile> files = RxList([]);
  final RxList<Map> fileUrls = RxList([]);

  pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) {
      Utils.showSnackBar('you didn\'t pick any files', status: false);
      files.clear();
      return;
    }
    files(result.files);
  }

  Future<bool> uploadFiles(List<PlatformFile> uploadfiles) async {
    List<Map>? recFileData =
        await UploadController.multipleFiles(uploadfiles, 'message_files');

    if (recFileData == null || recFileData.isEmpty) return false;

    fileUrls(recFileData);
    return true;
  }

  /// - - - - - - - - - - - - - - - - - - - `UPLOAD ACTIVITY`
  uploadActivity() async {
    if (files.isEmpty) {
      Utils.showSnackBar('please pick file', status: false);
      return;
    }

    if (descController.text.trim() == '') {
      Utils.showAlert(
        'Oops !',
        'hey, please fill out your new message before you submit.',
      );
      return;
    }

    try {
      if (!await uploadFiles(files)) {
        Utils.normalDialog();
        return;
      }

      Utils.progressIndctr(label: 'uploading...');
      final stdMap = await MyHelper.fetchStudentMap();
      final actId = uuid.v1();

      fire
          .collection('students')
          .doc(stdMap['usn'])
          // stdMap['usn']
          .collection('activity_points')
          .doc(actId)
          .set({
        'id': actId,
        'description': descController.text.trim(),
        'pdfUrl': fileUrls[0],
        'hours': hoursController.text.trim().toString(),
        'status': false,
        'points': (int.parse(hoursController.text.trim()) / 4).toString(),
      });

      Get.close(2);
      Utils.showSnackBar('Upload successful!', status: true);
    } catch (e) {
      Get.back();
      log(e.toString());
      Utils.showAlert('oops', e.toString());
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
                  /// ---------------------------------------  `year dropdown`

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
                            icon: Icons.add_alarm_rounded,
                            radius: 10,
                            inputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 15),

                        /// -------------------------------------- `credits`
                        MyOutlinedBtn(
                          files.isEmpty ? 'Pick File' : 'Picked',
                          () => pickFiles(),
                        ),
                      ],
                    ),
                  ),

                  /// --------------------------------------- `file check box`
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
