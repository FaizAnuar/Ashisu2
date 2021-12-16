import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference users =
    FirebaseFirestore.instance.collection('Users');
FirebaseAuth auth = FirebaseAuth.instance;
String uid = auth.currentUser.uid.toString();
final firestoreInstance = FirebaseFirestore.instance;

Future<void> userSetup(String displayName, String email) async {
  users.doc(uid).set({'displayName': displayName, 'email': email});
  return;
}
