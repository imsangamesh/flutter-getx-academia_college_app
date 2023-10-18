import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/utilities/utils.dart';

import '../core/constants/my_constants.dart';

class UploadController {
  //
  // ======================= upload multiple files ===================
  static Future<List<Map>?> multipleFiles(
    dynamic files,
    String refName,
  ) async {
    try {
      List<Map> fileDataList = [];
      Utils.progressIndctr(label: 'uploading...');

      for (int i = 0; i < files.length; i++) {
        final fileDataMap = {};

        TaskSnapshot taskSnapshot = await store
            .ref()
            .child(refName)
            .child('file-${i + 1}')
            .putFile(File(files[i].path));

        fileDataMap['name'] =
            'File ${i + 1}${MyHelper.getFileExtension(files[i].path)}';
        fileDataMap['url'] = await taskSnapshot.ref.getDownloadURL();

        fileDataList.add(fileDataMap);
      }
      Get.back();
      return fileDataList;
    } on FirebaseException catch (e) {
      Get.back();
      Utils.showAlert(e.code, e.message.toString());
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
    return null;
  }

  // ======================= upload event images ===================
  // static Future<List<String>?> newEventImages(
  //   String title,
  //   List<XFile> images,
  // ) async {
  //   try {
  //     List<String> imageUrls = [];
  //     Utils.progressIndctr(label: 'uploading...');

  //     for (int i = 0; i < images.length; i++) {
  //       TaskSnapshot taskSnapshot = await store
  //           .ref()
  //           .child('events')
  //           .child('$title _ $i')
  //           .putFile(File(images[i].path));

  //       imageUrls.add(await taskSnapshot.ref.getDownloadURL());
  //     }
  //     Get.back();
  //     return imageUrls;
  //   } on FirebaseException catch (e) {
  //     Get.back();
  //     Utils.showAlert(e.code, e.message.toString());
  //   } catch (e) {
  //     Get.back();
  //     Utils.normalDialog();
  //   }
  //   return null;
  // }

  // ======================= events firestore ===================
  // static updEventDataToFire(EventModel em) async {
  //   try {
  //     Utils.progressIndctr(label: 'updating');
  //     await fire.collection('events').doc(em.eid).set(em.toMap());

  //     Get.offAll(const HomeScreen());
  //     Utils.showSnackBar('new event updated.', yes: true, millSecs: 1800);
  //   } on FirebaseException catch (e) {
  //     Get.back();
  //     Utils.showAlert(e.code, e.message.toString());
  //   } catch (e) {
  //     Get.back();
  //     Utils.normalDialog();
  //   }
  // }
}
