import 'package:cloud_firestore/cloud_firestore.dart';

class PlacementMsgModel {
  String id;
  String title;
  String description;
  String date;
  String year;
  List<dynamic> links;
  List<dynamic> imageUrls;
  List<dynamic> fileUrls;
  Timestamp createdAt;

  PlacementMsgModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.year,
    required this.links,
    required this.imageUrls,
    required this.fileUrls,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'year': year,
      'links': links,
      'imageUrls': imageUrls,
      'fileUrls': fileUrls,
      'createdAt': createdAt,
    };
  }

  List<dynamic> toList() {
    return [
      id,
      title,
      description,
      date,
      year,
      links,
      imageUrls,
      fileUrls,
      createdAt,
    ];
  }

  static PlacementMsgModel fromMap(Map<String, dynamic> map) {
    return PlacementMsgModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      year: map['year'],
      links: map['links'],
      imageUrls: map['imageUrls'],
      fileUrls: map['fileUrls'],
      createdAt: map['createdAt'],
    );
  }

  static PlacementMsgModel fromList(List<dynamic> listOfPlacementMsgModel) {
    return PlacementMsgModel(
      id: listOfPlacementMsgModel[0],
      title: listOfPlacementMsgModel[1],
      description: listOfPlacementMsgModel[2],
      date: listOfPlacementMsgModel[3],
      year: listOfPlacementMsgModel[4],
      links: listOfPlacementMsgModel[5],
      fileUrls: listOfPlacementMsgModel[6],
      imageUrls: listOfPlacementMsgModel[7],
      createdAt: listOfPlacementMsgModel[8],
    );
  }

  static PlacementMsgModel fromSnapShot(DocumentSnapshot snapshot) {
    final snapData = snapshot.data() as Map<String, dynamic>;

    return PlacementMsgModel(
      id: snapData['id'],
      title: snapData['title'],
      description: snapData['description'],
      date: snapData['date'],
      year: snapData['year'],
      links: snapData['links'],
      imageUrls: snapData['imageUrls'],
      fileUrls: snapData['fileUrls'],
      createdAt: snapData['createdAt'],
    );
  }
}
