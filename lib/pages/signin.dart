import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:microlearning/controller/app_controller.dart';
import 'package:microlearning/firebase_options.dart';
import 'package:microlearning/pages/utils.dart';
import 'package:microlearning/services/firestore_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AppController controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appbarTitle(context),
      ),
      body: SignInScreen(
        providerConfigs: [
          //const EmailProviderConfiguration(),
          GoogleProviderConfiguration(clientId: DefaultFirebaseOptions.currentPlatform.appId),
        ],
        actions: [
          AuthStateChangeAction<SignedIn>((context, signedin) {
            log(signedin.user!.uid);

            // check if user is already registered
            final userId = '${signedin.user!.uid}';
            final userDisplayName = '${signedin.user!.displayName}';
            firebaseFirestore.collection("users").doc(userId).get().then((doc) {
              if (doc.exists) {
                // user is already registered
                log("user is already registered");
                // // set controller data
                // final userCredit = doc.data()!['credit'];
                controller.setUserData(userId, userDisplayName);
                Beamer.of(context).beamToReplacementNamed("/profile");
              } else {
                // user is not registered
                log("user is not registered");
                // create default user profile, set credit to 0
                // firebaseFirestore.collection("users").doc(userId).set({
                //   "credit": 99,
                //   "createdAt": DateTime.now(),
                // }).then((value) {
                //   // set default credit
                //   const userCredit = 99;
                controller.setUserData(userId, userDisplayName);
                // goto profile page
                Beamer.of(context).beamToReplacementNamed("/profile");
                // });
              }
            });
          }),
        ],
      ),
    );
  }
}
