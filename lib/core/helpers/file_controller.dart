import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/utils/popup.dart';

class FileController {
  /// ------------------------------- `UPLOAD SINGLE`
  static Future<Map<String, String>?> uploadSingle(File file) async {
    try {
      Popup.loading(label: 'Uploading Files');

      final Map<String, String> fileData = {};

      TaskSnapshot taskSnapshot = await store
          .ref()
          .child(timeId)
          .child(file.uri.pathSegments.last)
          .putFile(file);

      fileData['name'] = file.uri.pathSegments.last;
      fileData['url'] = await taskSnapshot.ref.getDownloadURL();
      fileData['delete_ref'] = taskSnapshot.ref.fullPath;

      log(fileData.toString());
      return fileData;
    } on FirebaseException catch (e) {
      Popup.alert(e.code, e.message.toString());
    } catch (e) {
      Popup.general();
    } finally {
      Popup.terminateLoading();
    }
    return null;
  }

  /// ------------------------------- `UPLOAD MULTIPLE`
  static Future<List<Map<String, String>>?> uploadMultiple(
      List<File> files) async {
    try {
      Popup.loading(label: 'Uploading Files');

      final List<Map<String, String>> filesDataList = [];
      for (var eachFile in files) {
        final Map<String, String> fileData = {};

        TaskSnapshot taskSnapshot = await store
            .ref()
            .child(timeId)
            .child(eachFile.uri.pathSegments.last)
            .putFile(eachFile);

        fileData['name'] = eachFile.uri.pathSegments.last;
        fileData['url'] = await taskSnapshot.ref.getDownloadURL();
        fileData['delete_ref'] = taskSnapshot.ref.fullPath;

        filesDataList.add(fileData);
      }

      return filesDataList;
    } on FirebaseException catch (e) {
      Popup.alert(e.code, e.message.toString());
    } catch (e) {
      Popup.general();
    } finally {
      Popup.terminateLoading();
    }
    return null;
  }

  /// ------------------------------- `DOWNLOAD FILE`
  // static Future<File?> downloadFile(String url, String fileName) async {
  //   try {
  //     Popup.loading(label: 'Downloading File');

  //     final appStorage = await getApplicationSupportDirectory();
  //     final file = File('${appStorage.path}/$fileName');

  //     final response = await Dio().get(
  //       url,
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         followRedirects: false,
  //         receiveTimeout: const Duration(seconds: 0),
  //       ),
  //     );

  //     final raf = file.openSync(mode: FileMode.write);
  //     raf.writeFromSync(response.data);
  //     await raf.close();

  //     Popup.terminateLoading();
  //     Popup.snackbar('Download Successful!');
  //     return file;
  //   } catch (e) {
  //     Popup.terminateLoading();
  //     Popup.alert(
  //       'Oops!',
  //       'Error in downloading the file! Please try again later...',
  //     );
  //   }
  //   return null;
  // }
  // ======================= upload event images ===================
  // static Future<List<String>?> newEventImages(
  //   String title,
  //   List<XFile> images,
  // ) async {
  //   try {
  //     List<String> imageUrls = [];
  //     Popup.progress(label: 'uploading...');

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
  //     Popup.alert(e.code, e.message.toString());
  //   } catch (e) {
  //     Get.back();
  //     Popup.general();
  //   }
  //   return null;
  // }

  // ======================= events firestore ===================
  // static updEventDataToFire(EventModel em) async {
  //   try {
  //     Popup.progress(label: 'updating');
  //     await fire.collection('events').doc(em.eid).set(em.toMap());

  //     Get.offAll(const HomeScreen());
  //     Popup.showSnackBar('new event updated.', yes: true, millSecs: 1800);
  //   } on FirebaseException catch (e) {
  //     Get.back();
  //     Popup.alert(e.code, e.message.toString());
  //   } catch (e) {
  //     Get.back();
  //     Popup.general();
  //   }
  // }
}
