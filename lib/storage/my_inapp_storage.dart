import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../core/utilities/utils.dart';

class MyInAppStorage {
  static Future<File?> downloadAndSaveFile(
      String downloadLink, String filename) async {
    try {
      Utils.progressIndctr(label: 'downloading...');

      final appStorage = await getApplicationDocumentsDirectory();
      final fileDirectory = Directory('${appStorage.path}/$filename');

      // Ensure that the directory exists, create it if it doesn't.
      if (!await fileDirectory.exists()) {
        fileDirectory.createSync(recursive: true);
      }

      final filePath = '${fileDirectory.path}/$filename';
      final myFile = File(filePath);

      final response = await Dio().get(
        downloadLink,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Write the downloaded data to the file
      await myFile.writeAsBytes(response.data);

      Get.back();
      Utils.showSnackBar('downloaded', status: true);
      return myFile;
    } catch (e) {
      Get.back();
      Utils.normalDialog();
      log(e.toString());
      return null;
    }
  }
}
