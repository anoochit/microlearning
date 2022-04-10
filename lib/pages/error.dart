import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 100, color: Colors.red),
            const Text(
              'ไม่พบหน้าที่คุณต้องการ',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.offNamed("/course");
              },
              child: const Text("กลับไปหน้ารายวิชา"),
            )
          ],
        ),
      ),
    );
  }
}
