import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final auth = FirebaseAuth.instance;
final fire = FirebaseFirestore.instance;
final store = FirebaseStorage.instance;
final timeId = const Uuid().v1();

const fcmServerKey =
    'AAAAKirdSz0:APA91bG5LSmeKEYQxNw6kgfxIB8Z_0O8bfunM2_QcU8-QFdCoiSNzrzm8EReAzUYe8XcM0VwTPx-fq-lpXB1fVWFlNJKcG_RlmjXEfWLNtcH41km_3JdJ3YnFiKD7b49bx9KuQoVpfvv';
