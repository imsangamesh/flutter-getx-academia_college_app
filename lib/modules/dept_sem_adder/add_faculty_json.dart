import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/my_constants.dart';
import 'package:newbie/core/utilities/utils.dart';
import 'package:newbie/core/widgets/my_buttons.dart';

import '../../core/widgets/custom_textfield.dart';

class AddFacultyJson extends StatelessWidget {
  AddFacultyJson({super.key});

  final facultyController = TextEditingController();

  Future<void> uploadJsonDataToFirestore(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      Utils.progressIndctr();
      List<dynamic> jsonList = jsonDecode(facultyController.text.trim());

      // - - - - - - - - - - - deleting
      final batch = fire.batch();
      var snapshots = await fire.collection('faculties').get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // - - - - - - - - - - - uploading
      for (var jsonItem in jsonList) {
        await fire.collection('faculties').doc().set(jsonItem);
      }

      Get.close(2);
      Utils.showSnackBar('Faculties added', status: true);
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Faculties')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: CustomTextField(
                facultyController,
                'faculties json',
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
