import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microlearning/controller/app_controller.dart';
import 'package:microlearning/pages/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppController controller = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    authStateChange(controller: controller);
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
                    children: [
                      // title

                      // featured

                      // courses
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
