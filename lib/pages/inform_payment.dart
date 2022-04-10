import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:microlearning/pages/utils.dart';

class InformPaymentPage extends StatefulWidget {
  const InformPaymentPage({Key? key}) : super(key: key);

  @override
  _InformPaymentPageState createState() => _InformPaymentPageState();
}

class _InformPaymentPageState extends State<InformPaymentPage> {
  Uint8List? imageBytes = null;

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
              width: 970,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- infrom payment ---
                  const Text("แจ้งโอนเงิน", style: TextStyle(fontSize: 28)),
                  const SizedBox(height: 16),
                  const Text(
                      "Voluptate commodo ut cillum culpa tempor enim reprehenderit occaecat. Occaecat ad nostrud proident dolor aliqua enim consequat aute mollit id laboris aliqua. Sit consequat nostrud officia velit adipisicing. Sint anim ad minim ad consectetur. Fugiat et fugiat labore id laborum consectetur aliquip sunt qui consectetur sit nostrud non. Laboris enim aliqua qui nostrud culpa quis."),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text("วันที่", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      ElevatedButton(
                        child: Text("เลือกวันที่..."),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 3)),
                            lastDate: DateTime.now().add(Duration(days: 3)),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text("เวลา", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      ElevatedButton(
                        child: Text("เลือกเวลา..."),
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text("แนบหลักฐานการโอนเงิน", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),
                      ElevatedButton(
                        child: const Text("เลือกไฟล์ภาพ..."),
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

                          if (image != null) {
                            final Uint8List? bytes = await image.readAsBytes();
                            if (bytes != null) {
                              setState(() {
                                imageBytes = bytes;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  (imageBytes != null)
                      ? Image.memory(
                          imageBytes!,
                          width: 200,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Container(),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: Text("แจ้งโอนเงิน"),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
