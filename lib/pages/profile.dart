import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:microlearning/controller/app_controller.dart';
import 'package:microlearning/pages/utils.dart';
import 'package:microlearning/services/authentication_service.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AppController controller = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appbarTitle(context),
      ),
      body: SafeArea(
        left: true,
        right: true,
        bottom: true,
        top: true,
        minimum: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 960,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      const Text("ข้อมูลผู้ใช้", style: TextStyle(fontSize: 28)),
                      const SizedBox(height: 16),

                      // profile detail
                      Row(
                        children: [
                          // avatar
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(firebaseAuth.currentUser!.photoURL ?? ""),
                          ),

                          const SizedBox(
                            width: 16,
                          ),

                          // displayname
                          Text(firebaseAuth.currentUser!.displayName ?? "No Name",
                              style: const TextStyle(fontSize: 24)),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      // credit total
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.savings,
                      //       size: 32,
                      //     ),
                      //     const SizedBox(
                      //       width: 16,
                      //     ),
                      //     Obx(
                      //       () => Text('เครดิตคงเหลือ = ${controller.userCredit.value.toString()}'),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(
                        height: 16,
                      ),

                      // list menu
                      ResponsiveBuilder(builder: (context, sizingInformation) {
                        var width = (constraints.maxWidth / 6);
                        if (sizingInformation.isDesktop) {
                          width = (constraints.maxWidth / 6);
                        } else if (sizingInformation.isTablet) {
                          width = (constraints.maxWidth / 4);
                        } else {
                          width = (constraints.maxWidth / 2);
                        }
                        return Wrap(
                          children: profileMenu.map((item) {
                            return SizedBox(
                              width: width,
                              height: width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(item.icon, size: 64),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(item.title),
                                    ],
                                  ),
                                  onTap: () {
                                    switch (item.slug) {
                                      case "payment":
                                        // add credit
                                        Beamer.of(context).beamToNamed('/payment');
                                        break;

                                      case "inform_payment":
                                        Beamer.of(context).beamToNamed('/inform_payment');
                                        break;

                                      case "delete_account":
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("ยืนยันการลบบัญชี"),
                                                content: const Text(
                                                    "เมื่อลบบัญชีคุณไม่สามารถเรียกคืนข้อมูลได้ คุณต้องการลบบัญชีนี้หรือไม่"),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("ยกเลิก"),
                                                    onPressed: () {
                                                      Beamer.of(context).popRoute();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text("ยืนยัน"),
                                                    onPressed: () {
                                                      firebaseAuth.currentUser!.delete().then(
                                                            (value) => Beamer.of(context).beamToReplacementNamed("/"),
                                                          );
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                        break;

                                      case "logout":
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("ยืนยันการออกจากระบบ"),
                                                content: const Text("คุณต้องการออกจากระบบหรือไม่"),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("ยกเลิก"),
                                                    onPressed: () {
                                                      Beamer.of(context).popRoute();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text("ยืนยัน"),
                                                    onPressed: () {
                                                      firebaseAuth.signOut().then(
                                                            (value) => Beamer.of(context).beamToReplacementNamed("/"),
                                                          );
                                                    },
                                                  ),
                                                ],
                                              );
                                            });

                                        break;
                                    }
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenu {
  IconData icon;
  String title;
  String slug;
  ProfileMenu({
    required this.icon,
    required this.title,
    required this.slug,
  });
}

List<ProfileMenu> profileMenu = [
  //ProfileMenu(icon: Icons.savings, title: "เครดิตคงเหลือ", slug: "remain_credit"),
  ProfileMenu(icon: Icons.monetization_on_outlined, title: "ชำระเงิน", slug: "payment"),
  ProfileMenu(icon: Icons.request_quote, title: "แจ้งโอนเงิน", slug: "inform_payment"),
  //ProfileMenu(icon: Icons.delete, title: "ลบบัญชีผู้ใช้", slug: "delete_account"),
  ProfileMenu(icon: Icons.logout, title: "ล็อกเอาท์", slug: "logout"),
];
