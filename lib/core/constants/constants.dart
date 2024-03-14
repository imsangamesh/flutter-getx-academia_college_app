import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:uuid/uuid.dart';

final auth = FirebaseAuth.instance;
final fire = FirebaseFirestore.instance;
final store = FirebaseStorage.instance;
final timeId = const Uuid().v1();
final role = AppData.fetchRole();
