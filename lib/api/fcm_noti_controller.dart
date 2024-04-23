import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/attendence/student_attendence_analytics.dart';
import 'package:newbie/modules/placement/placement_chat_page.dart';
import 'package:newbie/modules/result/result_analytics.dart';

class FCMNotiController extends GetxController {
  final _fcm = FirebaseMessaging.instance;
  final _box = GetStorage();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init({bool setToken = true}) async {
    await _requestPermissions();
    if (setToken) await _setUpToken();
    await _initInformation();
    log(' - - - - - - Notification INIT Complete! - - - - - - ');
  }

  Future<void> navigate(String? payload) async {
    /// `PLACEMENT`
    if (payload == FCMTitles.placement) {
      final year = MyHelper.semToYear(AppData.fetchData()['sem']);
      Get.to(() => PlacementChatPage(year));
    }

    /// `RESULT`
    if (payload == FCMTitles.result) {
      Get.to(() => const ResultAnalytics());
    }

    /// `Attendance`
    if (payload == FCMTitles.attendance) {
      Get.to(() => const StudentAttendanceAnalytics());
    }
  }

  /// `SEND MESSAGE` ----------------------------------------------------
  Future<void> send({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmServerKey',
        },
        body: jsonEncode({
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          'notification': {
            'title': title,
            'body': body,
            'android_channel_id': 'academia'
          },
          'to': token
        }),
      );
    } catch (e) {
      Popup.alert('Error!', e.toString());
      log('FCM SEND ERROR: $e');
    }
  }

  /// `INIT INFORMATION` ----------------------------------------------------
  Future<void> _initInformation() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null && details.payload!.isNotEmpty) {
          log(' - - - - - - ON NOTIFICATION TAP - - - - - - ');
          navigate(details.payload);
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log(' - - - - - - ON_MESSAGE RECEIVED - - - - - - ');
      log('Title: ${message.notification?.title}');
      log('Body: ${message.notification?.body}');

      final bigTextStyleInfomation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      final androidNotificationDetails = AndroidNotificationDetails(
        'academia',
        'academia',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: bigTextStyleInfomation,
        playSound: true,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(android: androidNotificationDetails),
        payload: message.data['title'],
      );
    });
  }

  /// `SET UP TOKEN` ----------------------------------------------------
  Future<void> _setUpToken() async {
    if (AppData.role == Role.admin || AppData.role == Role.faculty) return;

    final token = await _fcm.getToken();
    if (token == null) {
      Popup.alert(
        'Alert!',
        'Notifications token couldn\'t be restored, please try again!',
      );
      return;
    }

    final usn = AppData.fetchData()['usn'];
    if (AppData.role == Role.student) {
      await fire.collection(FireKeys.students).doc(usn).update({
        'token': token,
      });
    } else if (AppData.role == Role.parent) {
      await fire.collection(FireKeys.students).doc(usn).update({
        'parentToken': token,
      });
    }

    await _box.write(PrefKeys.token, token);
    Popup.snackbar('Notification set up successful!', status: true);
    log(' - - - - - - TOKEN set-up Complete: ${AppData.role} - - - - - - ');
  }

  /// `REQUEST PERMISSIONS` -------------------------------------------------
  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log(' - - - - - - Notification permission GRANTED! - - - - - - ');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log(' - - - - - Notification PROVISIONAL permission granted! - - - - - ');
    } else {
      log(' - - - - - - Notification permission DENIED! - - - - - - ');
    }
  }
}
