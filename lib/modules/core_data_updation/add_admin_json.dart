import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_buttons.dart';

import '../../core/widgets/custom_textfield.dart';

class AddAdminJson extends StatelessWidget {
  AddAdminJson({super.key});

  final adminController = TextEditingController();

  Future<void> uploadJsonDataToFirestore(BuildContext context) async {
    FocusScope.of(context).unfocus();

    try {
      Popup.loading();
      List<dynamic> jsonList = jsonDecode(adminController.text.trim());

      // - - - - - - - - - - - deleting
      final batch = fire.batch();
      var snapshots = await fire.collection('admins').get();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // - - - - - - - - - - - uploading
      for (var jsonItem in jsonList) {
        await fire.collection('admins').doc().set(jsonItem);
      }

      Get.close(2);
      Popup.snackbar('Admins added', status: true);
    } catch (e) {
      Get.back();
      Popup.general();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Admins')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: CustomTextField(
                adminController,
                'admins json',
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
