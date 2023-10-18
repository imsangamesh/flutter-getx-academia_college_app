import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final auth = FirebaseAuth.instance;
final fire = FirebaseFirestore.instance;
final store = FirebaseStorage.instance;
const uuid = Uuid();
