import 'dart:ui';

import 'package:Ashisu/models/NotesPage.dart';
import 'package:Ashisu/models/timetablePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference users =
    FirebaseFirestore.instance.collection('Users');
FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser.uid.toString();
final firestoreInstance = FirebaseFirestore.instance;

Future<void> userSetup(String displayName, String email) async {
  users.doc(uid).set({
    'displayName': displayName,
    'email': email,
  });
  users.doc(uid).set({
    'noteHeading': noteHeading,
    'noteDescription': noteDescription,
  });
  users.doc(uid).set({
    'taskHeading': taskHeading,
    'taskDescription': taskDescription,
  });

  return;
}
