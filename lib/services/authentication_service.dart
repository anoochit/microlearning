import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

bool isSignIn() {
  if (firebaseAuth.currentUser != null) {
    log("check isSignIn : true");
    return true;
  } else {
    log("check isSignIn : false");
    return false;
  }
}
