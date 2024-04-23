import 'dart:developer';

import 'package:get/get.dart';
import 'package:newbie/api/fcm_noti_controller.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/data/college_data.dart';

class FCMApi {
  FCMApi._();

  static final _fcm = Get.put(FCMNotiController());

  /// --------------- `SEND RESULT UPDATES`
  static Future<void> sendResultUpdates(String sem, String body) async {
    final studSnap = await fire.collection(FireKeys.students).get();

    final studentTokens = studSnap.docs
        .map((e) => e.data())
        .where((each) => each['sem'] == sem)
        .map((e) => e['token'] ?? '')
        .where((e) => e != null && e != '')
        .toList();
    final parentTokens = studSnap.docs
        .map((e) => e.data())
        .where((each) => each['sem'] == sem)
        .map((e) => e['parentToken'] ?? '')
        .where((e) => e != null && e != '')
        .toList();

    log('NO of STUDENTS: ${studentTokens.length}');
    log(studentTokens.toString());

    log('NO of PARENTS: ${parentTokens.length}');
    log(parentTokens.toString());

    for (var i = 0; i < studentTokens.length; i++) {
      await _fcm.send(
        token: studentTokens[i],
        title: FCMTitles.result,
        body: body,
      );
      log('Sent messages to: ${i + 1} student');
    }

    for (var i = 0; i < parentTokens.length; i++) {
      await _fcm.send(
        token: parentTokens[i],
        title: FCMTitles.result,
        body: body,
      );
      log('Sent messages to: ${i + 1} parent');
    }

    Popup.snackbar('Result Notifications sent!', status: true);
  }

  /// --------------- `SEND Attendance UPDATES`
  static Future<void> sendAttendanceUpdates(String sem, String body) async {
    final studSnap = await fire.collection(FireKeys.students).get();

    final studentTokens = studSnap.docs
        .map((e) => e.data())
        .where((each) => each['sem'] == sem)
        .map((e) => e['token'] ?? '')
        .where((e) => e != null && e != '')
        .toList();
    final parentTokens = studSnap.docs
        .map((e) => e.data())
        .where((each) => each['sem'] == sem)
        .map((e) => e['parentToken'] ?? '')
        .where((e) => e != null && e != '')
        .toList();

    log('NO of STUDENTS: ${studentTokens.length}');
    log(studentTokens.toString());

    log('NO of PARENTS: ${parentTokens.length}');
    log(parentTokens.toString());

    for (var i = 0; i < studentTokens.length; i++) {
      await _fcm.send(
        token: studentTokens[i],
        title: FCMTitles.attendance,
        body: body,
      );
      log('Sent messages to: ${i + 1} student');
    }

    for (var i = 0; i < parentTokens.length; i++) {
      await _fcm.send(
        token: parentTokens[i],
        title: FCMTitles.attendance,
        body: body,
      );
      log('Sent messages to: ${i + 1} parent');
    }

    Popup.snackbar('Attendance Notifications sent!', status: true);
  }

  /// --------------- `SEND PLACEMENT UPDATES`
  static Future<void> sendPlacemntUpdates(String year, String body) async {
    var studentTokens = [];
    final studSnap = await fire.collection(FireKeys.students).get();

    if (year == CollegeData.years[0]) {
      studentTokens = studSnap.docs
          .map((e) => e.data())
          .where((each) => each['sem'] == '1' || each['sem'] == '2')
          .map((e) => e['token'] ?? '')
          .where((e) => e != null && e != '')
          .toList();
    } else if (year == CollegeData.years[1]) {
      studentTokens = studSnap.docs
          .map((e) => e.data())
          .where((each) => each['sem'] == '3' || each['sem'] == '4')
          .map((e) => e['token'])
          .where((e) => e != null && e != '')
          .toList();
    } else if (year == CollegeData.years[2]) {
      studentTokens = studSnap.docs
          .map((e) => e.data())
          .where((each) => each['sem'] == '5' || each['sem'] == '6')
          .map((e) => e['token'])
          .where((e) => e != null && e != '')
          .toList();
    } else if (year == CollegeData.years[3]) {
      studentTokens = studSnap.docs
          .map((e) => e.data())
          .where((each) => each['sem'] == '7' || each['sem'] == '8')
          .map((e) => e['token'])
          .where((e) => e != null && e != '')
          .toList();
    }

    log('NO of STUDENTS: ${studentTokens.length}');

    for (var i = 0; i < studentTokens.length; i++) {
      await _fcm.send(
        token: studentTokens[i],
        title: FCMTitles.placement,
        body: body,
      );
      log('Sent messages to: ${i + 1} student');
    }

    Popup.snackbar('Placement Notifications sent!', status: true);
  }
}

/*

var students = [];
final studSnap = await fire.collection(FireKeys.students).get();

if (year == 'First Year') {
  students = studSnap.docs
      .map((e) => e.data())
      .where((each) => each['sem'] == '1' || each['sem' == '2'])
      .map((e) => e['token'])
      .toList();
} else if (year == 'Second Year') {
  students = studSnap.docs
      .map((e) => e.data())
      .where((each) => each['sem'] == '3' || each['sem' == '4'])
      .map((e) => e['token'])
      .toList();
} else if (year == 'Third Year') {
  students = studSnap.docs
      .map((e) => e.data())
      .where((each) => each['sem'] == '5' || each['sem' == '6'])
      .map((e) => e['token'])
      .toList();
} else if (year == 'Final Year') {
  students = studSnap.docs
      .map((e) => e.data())
      .where((each) => each['sem'] == '7' || each['sem' == '8'])
      .map((e) => e['token'])
      .toList();
}

*/
