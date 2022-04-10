import 'dart:developer';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:microlearning/controller/app_controller.dart';
import 'package:microlearning/services/authentication_service.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:video_player/video_player.dart';

Widget appbarTitle(BuildContext context) {
  return Row(
    children: [
      titleAppBar(title: siteTitle, route: () => Beamer.of(context).beamToNamed(siteHome)),
      const Spacer(),
      getActionBarMenu(context)
    ],
  );
}

Widget getActionBarMenu(BuildContext context) {
  var deviceType = getDeviceType(MediaQuery.of(context).size);
  // show signin menu
  if (firebaseAuth.currentUser != null) {
    // check screen type
    if ((deviceType == DeviceScreenType.desktop) || (deviceType == DeviceScreenType.tablet)) {
      // show full menu
      return Row(
          children: signedInMenu
              .map(
                (e) => TextButton(
                  child: Text(
                    e.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // goto signin
                    context.beamToNamed(e.route);
                    // Get.toNamed(e.route);
                  },
                ),
              )
              .toList());
    } else {
      // show popup menu
      return PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry>[
          for (int i = 0; i < signedInMenu.length; i++)
            PopupMenuItem(
              value: signedInMenu[i].route,
              child: Text(signedInMenu[i].title),
              onTap: () {
                context.beamToNamed(signedInMenu[i].route);
              },
            ),
        ],
      );
    }
  } else {
    // show unsignin menu
    if ((deviceType == DeviceScreenType.desktop) || (deviceType == DeviceScreenType.tablet)) {
      return Row(
          children: unSignInMenu
              .map(
                (e) => TextButton(
                  child: Text(
                    e.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // goto signin
                    context.beamToNamed(e.route);
                    // Get.toNamed(e.route);
                  },
                ),
              )
              .toList());
    } else {
      // show popup menu
      return PopupMenuButton(
        icon: const Icon(Icons.menu),
        itemBuilder: (context) => <PopupMenuEntry>[
          for (int i = 0; i < unSignInMenu.length; i++)
            PopupMenuItem<String>(
              value: unSignInMenu[i].route,
              child: Text(unSignInMenu[i].title),
            ),
        ],
        onSelected: (value) => {
          context.beamToNamed(value.toString()),
        },
      );
    }
  }
}

authStateChange({required AppController controller}) {
  firebaseAuth.authStateChanges().listen((user) {
    if (user == null) {
      log("not signin");
      controller.userUid.value = "";
      controller.userDisplayName.value = "Null";
    } else {
      log("already signin");
      // set user data to app controller
      controller.userUid.value = user.uid;
      controller.userDisplayName.value = user.displayName!;
    }
  });
}

Widget titleAppBar({required String title, required route}) {
  return InkWell(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.school),
        const SizedBox(width: 8.0),
        Text(title),
      ],
    ),
    onTap: () => route(),
  );
}

final signedInMenu = [
  Menu(title: "หน้าหลัก", icon: Icons.bookmark, route: "/"),
  Menu(title: "รายวิชา", icon: Icons.bookmark, route: "/courses"),
  Menu(title: "ชำระเงิน", icon: Icons.contact_mail, route: "/payment"),
  Menu(title: "แจ้งโอนเงิน", icon: Icons.contact_mail, route: "/inform_payment"),
  Menu(title: "ข้อมูลผู้ใช้", icon: Icons.contact_mail, route: "/profile"),
  Menu(title: "ติดต่อ", icon: Icons.contact_mail, route: "/contact"),
];

final unSignInMenu = [
  Menu(title: "หน้าหลัก", icon: Icons.bookmark, route: "/"),
  Menu(title: "รายวิชา", icon: Icons.bookmark, route: "/courses"),
  Menu(title: "ติดต่อ", icon: Icons.contact_mail, route: "/contact"),
  Menu(title: "ล็อกอิน", icon: Icons.contact_mail, route: "/signin")
];

const siteTitle = "เรียนออนไลน์";
const siteHome = "/";

class Menu {
  final String title;
  final IconData icon;
  final String route;
  Menu({
    required this.title,
    required this.icon,
    required this.route,
  });
}

late VideoPlayerController videoPlayerController;
late ChewieController chewieController;
