import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wct/temp/tmp2.dart';

void main() => runApp(MyApp2(
      key: GlobalKey(),
    ));

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MyApp2Home(),
      getPages: [
        GetPage(name: "/", page: () => MyApp2Home()),
        GetPage(
          name: "/tmp2",
          page: () => const MyApp3Home(),
        )
      ],
      // defaultTransition: Transition.rightToLeft,
    );
  }
}

class MyApp2Home extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final UserProvider userProvider = UserProvider();

  MyApp2Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Obx(() => Text("${c.count}"))),
        body: Center(
            child: Column(children: <Widget>[
          Text("bbb"),
          ElevatedButton(
              onPressed: () {
                // Get.snackbar("您还未登录", "快去登录吧！");
                // Get.toNamed("/tmp2");
                // c.inc();
                // print(c.count);
               userProvider.getTest().then((value) => print(value.bodyString));
              },
              child: Text("btn"))
        ])));
  }
}

class Controller extends GetxController {
  RxInt count = 0.obs;

  inc() => count++;
}

class UserProvider extends GetConnect {
  // Get request
  Future<Response<String>> getTest() =>
     get("http://192.168.1.100:8080/test");
  // Post request
  Future<Response> postUser(Map data) => post("http://youapi/users", data);
  // // Post request with File
  // Future<Response<CasesModel>> postCases(List<int> image) {
  //   final form = FormData({
  //     "file": MultipartFile(image, filename: "avatar.png"),
  //     "otherFile": MultipartFile(image, filename: "cover.png"),
  //   });
  //   return post("http://youapi/users/upload", form);
  // }

  // GetSocket userMessages() {
  //   return socket("https://yourapi/users/socket");
  // }
}

//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() => _counter++);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text('$_counter', style: Theme.of(context).textTheme.headline4),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
