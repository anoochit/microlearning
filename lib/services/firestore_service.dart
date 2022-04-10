import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

getCourses() async {
  QuerySnapshot querySnapshot = await firebaseFirestore.collection('courses').get();
  return querySnapshot.docs;
}
