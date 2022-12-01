import 'package:auto_orientation/auto_orientation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../util/constant.dart';
import '../util/databus.dart';
import '../util/provider.dart';
import '../util/util.dart';

var logger = Logger();

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final Provider provider = Provider();

  final FocusNode _roomIDFocusNode = FocusNode();
  final TextEditingController _roomIdTextController =
      TextEditingController(text: '1');

  static const double iconSize = 42;
  static const double iconTextScaleFactor = 1.25;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // AutoOrientation.landscapeLeftMode();
    // AutoOrientation.portraitUpMode();

    _checkPermission();
    controller._checkUid();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, 30.0),
        child: AppBar(
          title: const Text('加入房间'),
        ),
      ),

      resizeToAvoidBottomInset: false,
      body: ListView(children: [
        Obx(() => Text(
              '你好，${controller.userName.value}',
              style: const TextStyle(fontSize: 24.0),
            )),
        Container(
          key: const Key('房间号输入框'),
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: TextField(
            focusNode: _roomIDFocusNode,
            controller: _roomIdTextController,
            decoration: const InputDecoration(
                labelText: '请输入房间号',
                floatingLabelStyle: TextStyle(fontSize: 24),
                labelStyle: TextStyle(fontSize: 32)),
          ),
        ),
        Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Container(
                margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                    width: context.width * 0.7,
                    child: controller._buildLocalRenderView(context)))),
            Flex(
              direction: Axis.vertical,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          iconSize: iconSize,
                          icon: Obx(() => Icon(controller._openVideo.value
                              ? Icons.video_call_outlined
                              : Icons.video_call_rounded)),
                          onPressed: () => controller._switchOpenVideo(),
                        ),
                        Obx(() => Text(
                            controller._openVideo.value ? '关闭视频' : '打开视频',
                            textScaleFactor: iconTextScaleFactor)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          iconSize: iconSize,
                          icon: Obx(() => Icon(controller._openAudio.value
                              ? Icons.keyboard_voice_rounded
                              : Icons.keyboard_voice_outlined)),
                          onPressed: () => controller._switchOpenAudio(),
                        ),
                        Obx(() => Text(
                            controller._openAudio.value ? '关闭音频' : '打开音频',
                            textScaleFactor: iconTextScaleFactor)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          iconSize: iconSize,
                          icon: Obx(() => Icon(controller._cameraIdx.value == 0
                              ? Icons.camera_alt_rounded
                              : Icons.camera_alt_outlined)),
                          onPressed: () => controller.switchCamera(),
                        ),
                        Obx(() => Text(
                            controller._cameraIdx.value == 0 ? '换成前摄' : '换成后摄',
                            textScaleFactor: iconTextScaleFactor)),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStatePropertyAll(Size(300, 32)),
                        // EdgeInsets.all(10.0)
                      ),
                      onPressed: () => _joinRoom(),
                      child: const Text(
                        '加入房间！',
                        style: TextStyle(fontSize: 24),
                      )),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }

  void _checkPermission() async {
    await [Permission.camera, Permission.microphone].request();
  }

  final GetStorage localStorage = GetStorage();

  void _joinRoom() {
    MemoryStorage.openVideo = controller._openVideo.value;
    MemoryStorage.openAudio = controller._openAudio.value;
    MemoryStorage.cameraIdx = controller._cameraIdx.value;

    int rid;
    try {
      rid = int.parse(_roomIdTextController.text);
    } catch (e) {
      Get.snackbar('房间号错误', '您输入的不是正确的房间号');
      return;
    }
    _roomIDFocusNode.unfocus();

    logger.d('加入房间$rid');
    MemoryStorage.rid = rid;
    provider.joinRoom(rid).then((value) {
      var respData = Util.getRespData(value);
      MemoryStorage.token = respData[C.token];
      MemoryStorage.roomName = respData[C.roomName];
      logger.d('房间名:${MemoryStorage.roomName}, token:${MemoryStorage.token}');
      Get.toNamed('/room');
    });
  }
}

class HomeController extends GetxController {
  final provider = Provider();
  final localStorage = GetStorage();

  final uid = ''.obs;
  final userName = ''.obs;

  void _checkUid() {
    if (!localStorage.hasData(C.uid)) {
      provider.createUser().then((value) {
        var respData = Util.getRespData(value);
        localStorage.write(C.uid, respData[C.uid]);
        localStorage.write(C.userName, respData[C.name]);
        _refreshUserName();
      });
    } else {
      _refreshUserName();
    }
  }

  void _refreshUserName() {
    userName.value = localStorage.read(C.userName);
  }

  final init = false.obs;
  final _openVideo = MemoryStorage.openVideo.obs; // 默认关闭视频
  final _openAudio = MemoryStorage.openAudio.obs; // 默认关闭音频
  final _cameraIdx = MemoryStorage.cameraIdx.obs; // 默认后置摄像头

  CameraController? cameraController;

  void _switchOpenVideo() {
    _openVideo.value = !_openVideo.value;
    if (_openVideo.value) {
      refreshCamera();
    }
  }

  void _switchOpenAudio() {
    _openAudio.value = !_openAudio.value;
  }

  Widget _buildLocalRenderView(BuildContext context) {
    if (_openVideo.value) {
      // 需要开启视频
      if (cameraController == null) {
        refreshCamera();
      }

      if (cameraController != null && !cameraController!.value.isInitialized) {
        cameraController?.initialize().then((_) {
          init.value = true;
        });
      }
    } else {
      return _buildContainer();
    }

    logger.d('相机初始化：${cameraController?.value.isInitialized}');
    if (!init.value || cameraController == null) {
      return _buildContainer();
    } else {
      logger.d('相机参数：${cameraController?.value.aspectRatio}');
      return AspectRatio(
        aspectRatio: 1 / cameraController!.value.aspectRatio,
        child: CameraPreview(cameraController!),
      );
    }
  }

  Widget _buildSizedBox(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  Widget _buildContainer() {
    return Container();
  }

  /// onInit 初始化
  @override
  void onInit() {
    logger.d('HomeController onInit!!');
    super.onInit();
  }

  /// onReady onInit之后一帧，用于一些事件：dialogs、async request等
  @override
  void onReady() {
    super.onReady();
    logger.d('HomeController onReady!!');

    _openVideo.value = MemoryStorage.openVideo;
    _openAudio.value = MemoryStorage.openAudio;
    _cameraIdx.value = MemoryStorage.cameraIdx;
    refreshCamera();
  }

  /// onClose onDelete之前，用于释放资源
  @override
  void onClose() {
    logger.d('HomeController onClose!!');
    super.onClose();
    init.value = false;
    cameraController?.dispose();

    localStorage.write(C.openVideo, _openVideo.value);
    localStorage.write(C.openAudio, _openAudio.value);
    localStorage.write(C.cameraIdx, _cameraIdx.value);
  }

  void switchCamera() {
    _cameraIdx.value = _cameraIdx.value == 0 ? 1 : 0;
    // cameraController?.dispose();
    refreshCamera();
  }

  void refreshCamera() {
    cameraController = CameraController(
        MemoryStorage.cameras[_cameraIdx.value], ResolutionPreset.medium);
    init.value = false;
  }
}
