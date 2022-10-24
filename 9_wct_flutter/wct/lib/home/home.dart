import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final _HomeController controller = Get.put(_HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("加入房间")),
        body: Column(children: [
          Obx(() => Text("${controller._intent}")),
          ElevatedButton(
              onPressed: () => controller.changeIntent(_Intent.create),
              child: const Text("create")),
          ElevatedButton(
              onPressed: () => controller.changeIntent(_Intent.join),
              child: const Text("join")),
          ElevatedButton(
              onPressed: () {
                Get.toNamed("/room");
              },
              child: const Text("rtc")),
        ]));
  }
}

class _HomeController extends GetxController {
  final _intent = _Intent.join.obs;

  _HomeController() {}

  void changeIntent(_Intent intent) {
    _intent.value = intent;
    debugPrint(_intent.toString());
  }
}

enum _Intent { join, create }
