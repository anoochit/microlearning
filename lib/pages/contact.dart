import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:microlearning/controller/app_controller.dart';
import 'package:microlearning/pages/utils.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
        child: Center(
            child: SizedBox(
          width: 960,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("ติดต่อ", style: TextStyle(fontSize: 28)),
              SizedBox(height: 16),
            ],
          ),
        )),
      ),
    );
  }
}
