import 'package:get/get.dart';

class AppController extends GetxController {
  RxString userUid = "".obs;
  RxString userDisplayName = "".obs;
  //RxInt userCredit = 0.obs;

  setUserData(String uid, String displayName) {
    userUid.value = uid;
    userDisplayName.value = displayName;
    //userCredit.value = credit;
    update();
  }
}
