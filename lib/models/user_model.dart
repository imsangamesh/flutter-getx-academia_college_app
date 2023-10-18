import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? profilepic;
  String? email;
  String? phone;
  String? semester;
  String? department;
  bool isprofilecomplete = false;

  UserModel({
    required this.uid,
    required this.name,
    required this.profilepic,
    required this.email,
    required this.phone,
    required this.semester,
    required this.department,
    required this.isprofilecomplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'profilepic': profilepic,
      'email': email,
      'phone': phone,
      'semester': semester,
      'department': department,
      'isprofilecomplete': isprofilecomplete,
    };
  }

  List<String> toList() {
    return [
      uid ?? '',
      name ?? '',
      profilepic ?? '',
      email ?? '',
      phone ?? '',
      semester ?? '',
      department ?? '',
      isprofilecomplete.toString(),
    ];
  }

  static UserModel fromList(List<String> listOfUserModel) {
    return UserModel(
      uid: listOfUserModel[0],
      name: listOfUserModel[1],
      profilepic: listOfUserModel[2],
      email: listOfUserModel[3],
      phone: listOfUserModel[4],
      semester: listOfUserModel[5],
      department: listOfUserModel[6],
      isprofilecomplete: listOfUserModel[7].toLowerCase() == 'true',
    );
  }

  static UserModel fromSnapShot(DocumentSnapshot snapshot) {
    final snapData = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapData['uid'],
      name: snapData['name'],
      profilepic: snapData['profilepic'],
      email: snapData['email'],
      phone: snapData['phone'],
      semester: snapData['semester'],
      department: snapData['department'],
      isprofilecomplete: snapData['isprofilecomplete'],
    );
  }
}

enum Role { student, faculty, admin }

// enum Department { aiml, au, bt, cs, cv, ece, ee, eie, ip, ise, me }

// enum Semester { pc, cc, s3, s4, s5, s6, s7, s8 }

// UserModel.fromMap(Map<String, dynamic> map) {
//   uid = map['uid'];
//   name = map['name'];
//   profilepic = map['profilepic'];
//   email = map['email'];
//   phone = map['phone'];
  // semester = map['semester'];
  // department = map['department'];
//   isprofilecomplete = map['isprofilecomplete'];
// }