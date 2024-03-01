class Student {
  // personal
  String authId;
  String usn;
  String name;
  String email;
  String phone;
  String parentEmail;
  // college
  String dept;
  String sem;
  String div;
  // faculty advisor
  String facultyEmail;
  String pendingActivities;

  Student({
    // personal
    required this.authId,
    required this.usn,
    required this.name,
    required this.email,
    required this.phone,
    required this.parentEmail,
    // college
    required this.dept,
    required this.sem,
    required this.div,
    // faculty advisor
    required this.facultyEmail,
    required this.pendingActivities,
  });

  Map<String, dynamic> toMap() => {
        'authId': authId,
        'usn': usn,
        'name': name,
        'email': email,
        'phone': phone,
        'parentEmail': parentEmail,
        'dept': dept,
        'sem': sem,
        'div': div,
        'facultyEmail': facultyEmail,
        'pendingActivities': pendingActivities,
      };

  Student fromMap(Map<String, dynamic> map) => Student(
        // personal
        authId: map['authId'],
        usn: map['usn'],
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        parentEmail: map['parentEmail'],
        // college
        dept: map['dept'],
        sem: map['sem'],
        div: map['div'],
        // faculty advisor
        facultyEmail: map['facultyEmail'],
        pendingActivities: map['pendingActivities'],
      );
}
