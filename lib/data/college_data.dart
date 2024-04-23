class CollegeData {
  //
  static const departments = {
    'CSE': 'Computer Science',
    'ISE': 'Information Science',
    'EI': 'Electronic & Instrumentation',
    'CV': 'Civil Engineering',
    'AIML': 'Artificial Intelligence',
    'BT': 'BioTechnology',
    'ECE': 'Electronics and Communication',
    'EEE': 'Electronics and Electrical',
    'ME': 'Mechanical Engineering',
    'IP': 'Industrial Production',
    'AU': 'Automobile Engineering',
  };
  static final shortDepts = departments.keys.toList();
  static final fullDepts = departments.values.toList();

  static const semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];

  static const years = [
    'First Year',
    'Second Year',
    'Third Year',
    'Final Year'
  ];

  static const divisions = ['A', 'B'];

  static const exams = ['CIE 1', 'CIE 2', 'Assignment', 'SEE'];
}

/// ----------------- `ACTIVITY STATUS`
enum ActivityStatus {
  pending('Pending'),
  approved('Approved'),
  rejected('Rejected');

  final String str;
  const ActivityStatus(this.str);

  static ActivityStatus fromStr(String str) {
    switch (str) {
      case 'Pending':
        return ActivityStatus.pending;
      case 'Approved':
        return ActivityStatus.approved;
      case 'Rejected':
        return ActivityStatus.rejected;
      default:
        return ActivityStatus.pending;
    }
  }
}

enum Role {
  student('Student'),
  faculty('Faculty'),
  admin('Admin'),
  parent('Parent');

  final String str;
  const Role(this.str);

  static Role fromStr(String str) {
    switch (str) {
      case 'Student':
        return Role.student;
      case 'Faculty':
        return Role.faculty;
      case 'Admin':
        return Role.admin;
      case 'Parent':
        return Role.parent;
      default:
        return Role.student;
    }
  }
}
