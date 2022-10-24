import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wct/temp/tmp.dart';

class MyApp3Home extends StatelessWidget {
  const MyApp3Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bbb"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("btn2"),
          onPressed: () {
            Get.offAll(MyApp2Home());
          },
        ),
      ),
    );
  }
}
