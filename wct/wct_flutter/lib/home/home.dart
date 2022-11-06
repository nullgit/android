import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final _HomeController controller = Get.put(_HomeController());
  final TmpProvider tmpProvider = TmpProvider();

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
              tmpProvider.getTest().then((value) {
                var string = value.bodyString;
                debugPrint(string);
              });
            },
            child: const Text("btn"),
          ),
          ElevatedButton(
              onPressed: () {
                Get.toNamed("/room");
              },
              child: const Text("rtc")),
        ]));
  }
}

class TmpProvider extends GetConnect {
  // Get request
  Future<Response<String>> getTest() => get("http://192.168.43.35:10000/test/1");
  // Post request
  // Future<Response> postUser(Map data) => post("http://youapi/users", data);
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
