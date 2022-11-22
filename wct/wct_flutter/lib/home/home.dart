import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../util/provider.dart';
import '../util/resp.dart';
import '../util/constant.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final LoginProvider loginProvider = LoginProvider();

  HomePage({super.key});

  // _checkUid() {
  //   SharedPreferences.getInstance().then((sp) {
  //     int? uid = sp.getInt("uid");
  //     if (uid == null) {
  //       loginProvider.createUser().then((r) {
  //         uid = r.body?[C.respData];
  //         sp.setInt(C.uid, uid!);
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // _checkUid();

    return Scaffold(
        appBar: AppBar(title: const Text("加入房间")),
        body: Column(children: [
          Obx(() => Text("${controller._intent}")),
          ElevatedButton(
              onPressed: () => controller.changeIntent(Intent.create),
              child: const Text("create")),
          ElevatedButton(
              onPressed: () => controller.changeIntent(Intent.join),
              child: const Text("join")),
          ElevatedButton(
            onPressed: () {
              loginProvider.getToken(1, 123).then((value) {
                String token = value.body?["respData"];
                debugPrint(token);
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

class HomeController extends GetxController {
  final _intent = Intent.join.obs;

  void changeIntent(Intent intent) {
    _intent.value = intent;
    debugPrint(_intent.toString());
  }
}

enum Intent { join, create }
