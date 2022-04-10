import 'dart:developer';
import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:microlearning/pages/utils.dart';
import 'package:microlearning/services/authentication_service.dart';
import 'package:microlearning/services/firestore_service.dart';
import 'package:promptpay/promptpay.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late String promptPayData;
  double courseTotalPrice = 0.0;

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
                  Text("ชำระเงิน", style: TextStyle(fontSize: 28)),
                  SizedBox(height: 16),

                  // check course which not paid
                  FutureBuilder(
                    future: firebaseFirestore
                        .collection("enrolls")
                        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
                        .where('paid', isEqualTo: false)
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // loading
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // error
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      snapshot.data!.docs.forEach((doc) {
                        courseTotalPrice += doc['coursePrice'];
                      });

                      // if no course
                      if (snapshot.data!.docs.length == 0) {
                        return Text("- คุณไม่มีคอร์สที่ยังไม่ได้ชำระเงิน -");
                      }

                      log('total course price = $courseTotalPrice');
                      promptPayData = PromptPay.generateQRData("0898433717", amount: courseTotalPrice);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("คอร์สที่ยังไม่ได้ชำระเงิน", style: TextStyle(fontSize: 20)),
                          SizedBox(height: 16),
                          Column(
                            children: snapshot.data!.docs.map((course) {
                              return Row(
                                children: [
                                  Icon(Icons.school),
                                  SizedBox(width: 8),
                                  Text(course['courseTitle']),
                                ],
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          Text("คุณสามารถชำระเงินผ่าน PromptPay ได้ที่นี่"),
                          SizedBox(height: 16),
                          promptPayQRCode(promptPayData),
                          SizedBox(height: 16),
                          Text("เมื่อโอนเงินเสร็จเรียบร้อยแล้ว กรุณาแจ้งการโอนเงิน"),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Beamer.of(context).beamToNamed("/inform_payment");
                            },
                            child: Text("แจ้งการโอนเงิน"),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget promptPayQRCode(String promptPayData) {
    return Column(
      children: [
        Image.network(
          "https://miro.medium.com/max/800/1*3JwIlFw0mHB-xFjUCvLpbQ.jpeg",
          width: 216,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200,
            height: 200,
            child: BarcodeWidget(data: promptPayData, barcode: Barcode.qrCode()),
          ),
        ),
      ],
    );
  }
}
