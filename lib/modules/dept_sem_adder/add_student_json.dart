import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/my_constants.dart';
import 'package:newbie/core/utilities/utils.dart';
import 'package:newbie/core/widgets/my_buttons.dart';

import '../../core/widgets/custom_textfield.dart';

class AddStudentJson extends StatelessWidget {
  AddStudentJson({super.key});

  final studentController = TextEditingController();

  Future<void> uploadJsonDataToFirestore(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      Utils.progressIndctr();
      List<dynamic> jsonList = jsonDecode(studentController.text);

      // - - - - - - - - - - - deleting
      final batch = fire.batch();
      var snapshots = await fire.collection('students').get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // - - - - - - - - - - - uploading
      log(jsonList.toString());
      for (var jsonItem in jsonList) {
        await fire.collection('students').doc(jsonItem['usn']).set(jsonItem);
        log(jsonItem['usn']);
      }

      Get.close(2);
      Utils.showSnackBar('Students added', status: true);
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Students')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: CustomTextField(
                studentController,
                'students json',
                50,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: MyElevatedBtn(
                  ' Upload ', () => uploadJsonDataToFirestore(context)),
            )
          ],
        ),
      ),
    );
  }
}
