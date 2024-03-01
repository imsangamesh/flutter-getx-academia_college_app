class Activity {
  String id;
  String description;
  Map<String, dynamic> fileDetails;
  int hours;
  String status;
  double points;

  Activity({
    required this.id,
    required this.description,
    required this.fileDetails,
    required this.hours,
    required this.status,
    required this.points,
  });

  static Activity fromMap(Map<String, dynamic> map) => Activity(
        id: map['id'],
        description: map['description'],
        fileDetails: map['fileDetails'],
        hours: map['hours'],
        status: map['status'],
        points: map['points'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        'fileDetails': fileDetails,
        'hours': hours,
        'status': status,
        'points': points,
      };
}
