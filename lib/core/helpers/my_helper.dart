import 'package:flutter/material.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/data/college_data.dart';

class MyHelper {
  //
  static Size scrSize(BuildContext context) => MediaQuery.of(context).size;

  /// ---------------------------------------------- `Department Funs`
  /// `long to short` department
  static l2sDept(String name) {
    for (var each in CollegeData.departments.entries) {
      if (name == each.value) return each.key;
    }
  }

  /// `short to long` department
  static s2lDept(String name) {
    for (var each in CollegeData.departments.entries) {
      if (name == each.value) return each.key;
    }
  }

  static String semToYear(String sem) {
    switch (sem) {
      case '1':
        return CollegeData.years[0];
      case '2':
        return CollegeData.years[0];
      case '3':
        return CollegeData.years[1];
      case '4':
        return CollegeData.years[1];
      case '5':
        return CollegeData.years[2];
      case '6':
        return CollegeData.years[2];
      case '7':
        return CollegeData.years[3];
      case '8':
        return CollegeData.years[3];
      default:
        return '1';
    }
  }

  /// ---------------------------------------------- `FETCH USER DATA`
  static Future<Map<String, dynamic>> fetchStudentMap() async {
    try {
      final email = auth.currentUser!.email;

      final studentsData = await fire.collection(FireKeys.students).get();
      final studentMap = studentsData.docs
          .map((e) => e.data())
          .firstWhere((stdMap) => stdMap['email'] == email);

      return studentMap;
    } catch (e) {
      Popup.alert('Oops!', 'Error while fetching core student data!');
      return {};
    }
  }

  static Future<Map<String, dynamic>> fetchFacultyMap() async {
    try {
      final email = auth.currentUser!.email;

      final facultyData = await fire.collection(FireKeys.faculties).get();
      final facultyMap = facultyData.docs
          .map((e) => e.data())
          .firstWhere((stdMap) => stdMap['email'] == email);

      return facultyMap;
    } catch (e) {
      Popup.alert('Oops!', 'Error while fetching core faculty data!');
      return {};
    }
  }

  static Future<Map<String, dynamic>> fetchAdminMap() async {
    try {
      final email = auth.currentUser!.email;

      final facultyData = await fire.collection(FireKeys.admins).get();
      final facultyMap = facultyData.docs
          .map((e) => e.data())
          .firstWhere((stdMap) => stdMap['email'] == email);

      return facultyMap;
    } catch (e) {
      Popup.alert('Oops!', 'Error while fetching core admin data!');
      return {};
    }
  }

  static String profilePic =
      'https://img.freepik.com/premium-psd/3d-cartoon-avatar-smiling-man_1020-5130.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.2.1025021015.1655558182&semt=sph';
}

class Dummy {
  static const lorem =
      '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum''';
}
