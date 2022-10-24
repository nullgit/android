import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wct/home/home.dart';
import 'package:wct/room/room.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomePage(),
      getPages: [
        GetPage(name: "/", page: () => HomePage()),
        GetPage(name: "/home", page: () => HomePage()),
        GetPage(name: "/room", page: () => RoomPage()),
      ],
      // defaultTransition: Transition.rightToLeft,
    );
  }
}
