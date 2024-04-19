import 'dart:developer';

import 'package:get/get.dart';
import 'package:newbie/api/fcm_noti_controller.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/data/college_data.dart';

class FCMApi {
  static final _fcm = Get.put(FCMNotiController());

  // Future<void> send(String token, String title, String body) async {
  //   await _fcm.send(token, title, body);
  // }

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
      log('Sent messages to: ${i + 1} user');
    }
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
