import 'package:cloud_firestore/cloud_firestore.dart';

class DeptSemDivModel {
  String dept;
  String sem;
  String div;
  String sub;
  String credits;
  String faculty;

  DeptSemDivModel({
    required this.dept,
    required this.sem,
    required this.div,
    required this.sub,
    required this.credits,
    required this.faculty,
  });

  Map<String, dynamic> toMap() {
    return {
      'dept': dept,
      'sem': sem,
      'div': div,
      'sub': sub,
      'credits': credits,
      'faculty': faculty,
    };
  }

  List<dynamic> toList() {
    return [
      dept,
      sem,
      div,
      sub,
      credits,
      faculty,
    ];
  }

  static DeptSemDivModel fromList(List<dynamic> listOfUserModel) {
    return DeptSemDivModel(
      dept: listOfUserModel[0],
      sem: listOfUserModel[1],
      div: listOfUserModel[2],
      sub: listOfUserModel[3],
      credits: listOfUserModel[4],
      faculty: listOfUserModel[5],
    );
  }

  static DeptSemDivModel fromSnapShot(DocumentSnapshot snapshot) {
    final snapData = snapshot.data() as Map<String, dynamic>;

    return DeptSemDivModel(
      dept: snapData['dept'],
      sem: snapData['sem'],
      div: snapData['div'],
      sub: snapData['sub'],
      credits: snapData['credits'],
      faculty: snapData['faculty'],
    );
  }
}
