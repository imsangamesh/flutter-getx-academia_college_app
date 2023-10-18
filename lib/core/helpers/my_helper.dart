import 'package:flutter/material.dart';
import 'package:newbie/core/constants/my_constants.dart';

import '../../models/user_model.dart';

class MyHelper {
  //
  static String getFileExtension(String filePath) {
    return ".${filePath.split('.').last}";
  }

  static Size scrSize(BuildContext context) => MediaQuery.of(context).size;

  static String profilePic =
      'https://img.freepik.com/premium-psd/3d-cartoon-avatar-smiling-man_1020-5130.jpg?size=338&ext=jpg&uid=R65626931&ga=GA1.2.1025021015.1655558182&semt=sph';

  static const departments = [
    {'dept': 'Computer Science', 'key': 'CSE'},
    {'dept': 'Information Science', 'key': 'ISE'},
    {'dept': 'Electronic & Instrumentation', 'key': 'EI'},
    {'dept': 'Civil Engineering', 'key': 'CV'},
    {'dept': 'Artificial Intelligence', 'key': 'AIML'},
    {'dept': 'BioTechnology', 'key': 'BT'},
    {'dept': 'Electronics and Communication', 'key': 'ECE'},
    {'dept': 'Electronics and Electrical', 'key': 'EEE'},
    {'dept': 'Mechanical Engineering', 'key': 'ME'},
    {'dept': 'Industrial Production', 'key': 'IP'},
    {'dept': 'Automobile Engineering', 'key': 'AU'},
  ];

  static String deptToKey(String dept) {
    return departments.firstWhere((each) => each['dept'] == dept)['key'] ?? '';
  }

  static String keyToDept(String key) {
    return departments.firstWhere((each) => each['key'] == key)['dept'] ?? '';
  }

  static String roleToString(Role role) {
    switch (role) {
      case Role.student:
        return 'Student';
      case Role.faculty:
        return 'Faculty';
      case Role.admin:
        return 'Admin';
      default:
        return '';
    }
  }

  static enumToString(dynamic enumData) => enumData.toString().split('.')[1];

  static Role stringToRole(String roleStr) {
    switch (roleStr) {
      case 'Student':
        return Role.student;
      case 'Faculty':
        return Role.faculty;
      case 'Admin':
        return Role.admin;
      default:
        return Role.student;
    }
  }

  static Future<Map> fetchStudentMap() async {
    final email = auth.currentUser!.email;

    final studentsData = await fire.collection('students').get();
    final studentMap = studentsData.docs
        .map((e) => e.data())
        .firstWhere((stdMap) => stdMap['email'] == email);

    return studentMap;
  }

  static Future<Map> fetchFacultyMap() async {
    final email = auth.currentUser!.email;

    final facultyData = await fire.collection('faculties').get();
    final facultyMap = facultyData.docs
        .map((e) => e.data())
        .firstWhere((stdMap) => stdMap['email'] == email);

    return facultyMap;
  }

  static String semToYear(String sem) {
    switch (sem) {
      case '1':
        return '1';
      case '2':
        return '1';
      case '3':
        return '2';
      case '4':
        return '2';
      case '5':
        return '3';
      case '6':
        return '3';
      case '7':
        return '4';
      case '8':
        return '4';
      default:
        return '1';
    }
  }
}
