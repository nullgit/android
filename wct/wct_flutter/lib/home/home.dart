import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../util/constant.dart';
import '../util/databus.dart';
import '../util/provider.dart';
import '../util/util.dart';

class HomePage extends StatelessWidget {
  final _logger = Logger();
  final _controller = Get.put(HomeController());
  final _provider = Provider();
  final _localStorage = GetStorage();

  // 页面相关成员
  final FocusNode _roomIDFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _roomIdTextController =
      TextEditingController(text: '1');
  final TextEditingController _passwordTextController =
      TextEditingController(text: '1');
  final TextEditingController _nameTextController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final _headImageFileBytes = Uint8List(0).obs;

  // 页面相关参数
  static const double iconSize = 42;
  static const double iconTextScaleFactor = 1.25;

  // 个人信息
  final userName = ''.obs;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    _checkPermission();
    _checkUid();
    _getHeadImage();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, 30.0),
        child: AppBar(
          centerTitle: true,
          title: const Text('加入房间'),
        ),
      ),
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Obx(() => SizedBox(
                        width: 50,
                        height: 50,
                        child: _buildHeadImage(),
                        // child: Image(image: FileImage(localStorage.read(C.headImage))),
                      )),
                  Obx(() => Text(
                        '你好，${userName.value}',
                        style: const TextStyle(fontSize: 24.0),
                      )),
                  TextButton(
                      onPressed: () async {
                        final XFile? photo = await _imagePicker.pickImage(
                            source: ImageSource.gallery);
                        var bytes = await photo?.readAsBytes();
                        _headImageFileBytes.value = bytes!;
                        _logger.d('更换头像');
                        _controller._localStorage.write(C.headImage, bytes);
                      },
                      child: const Text('换头像')),
                  TextButton(
                    child: const Text('改名'),
                    onPressed: () {
                      Get.defaultDialog(
                        title: '改名',
                        content: TextField(
                          controller: _nameTextController,
                          decoration: const InputDecoration(
                              floatingLabelStyle: TextStyle(fontSize: 24),
                              labelStyle: TextStyle(fontSize: 32)),
                        ),
                        onConfirm: () {
                          _rename(_nameTextController.text);
                        },
                      );
                    },
                  )
                ],
              ),
              TextField(
                focusNode: _roomIDFocusNode,
                controller: _roomIdTextController,
                decoration: const InputDecoration(
                    labelText: '请输入房间号',
                    floatingLabelStyle: TextStyle(fontSize: 24),
                    labelStyle: TextStyle(fontSize: 32)),
              ),
              TextField(
                focusNode: _passwordFocusNode,
                controller: _passwordTextController,
                obscureText: true, // 设置密码不可见
                decoration: const InputDecoration(
                    labelText: '请输入密码',
                    floatingLabelStyle: TextStyle(fontSize: 24),
                    labelStyle: TextStyle(fontSize: 32)),
              ),
            ],
          ),
        ),
        Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Container(
                margin: const EdgeInsets.all(10.0),
                child: SizedBox(
                    width: context.width * 0.5,
                    child: _controller._buildLocalRenderView(context)))),
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
                          icon: Obx(() => Icon(_controller._openVideo.value
                              ? Icons.video_call_outlined
                              : Icons.video_call_rounded)),
                          onPressed: () => _controller._switchOpenVideo(),
                        ),
                        Obx(() => Text(
                            _controller._openVideo.value ? '关闭视频' : '打开视频',
                            textScaleFactor: iconTextScaleFactor)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          iconSize: iconSize,
                          icon: Obx(() => Icon(_controller._openAudio.value
                              ? Icons.keyboard_voice_outlined
                              : Icons.keyboard_voice_rounded)),
                          onPressed: () => _controller._switchOpenAudio(),
                        ),
                        Obx(() => Text(
                            _controller._openAudio.value ? '关闭音频' : '打开音频',
                            textScaleFactor: iconTextScaleFactor)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          iconSize: iconSize,
                          icon: Obx(() => Icon(_controller._cameraIdx.value == 0
                              ? Icons.camera_alt_outlined
                              : Icons.camera_alt_rounded)),
                          onPressed: () => _controller._switchCamera(),
                        ),
                        Obx(() => Text(
                            _controller._cameraIdx.value == 0 ? '换成前摄' : '换成后摄',
                            textScaleFactor: iconTextScaleFactor)),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      style: const ButtonStyle(
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

  /// 检查权限
  void _checkPermission() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.audio,
    ].request();
  }

  /// 检查是否有身份
  void _checkUid() {
    if (!_localStorage.hasData(C.uid)) {
      _provider.createUser().then((value) {
        var respData = Util.getRespData(value);
        _localStorage.write(C.uid, respData[C.uid]);
        _localStorage.write(C.userName, respData[C.name]);
        _refreshUserName();
      });
    } else {
      _refreshUserName();
    }
  }

  /// 本地存储获取头像
  void _getHeadImage() {
    List? read = _localStorage.read(C.headImage);
    if (read != null) {
      var uint8list = Uint8List(read.length);
      for (int i = 0; i < read.length; ++i) {
        uint8list[i] = read[i];
      }
      _headImageFileBytes.value = uint8list;
    }
  }

  /// 刷新昵称
  void _refreshUserName() {
    userName.value = _localStorage.read(C.userName);
  }

  /// 构建头像
  Widget _buildHeadImage() {
    return _headImageFileBytes.value.isEmpty
        ? const Image(image: AssetImage('images/head.jpeg'))
        : Image(image: MemoryImage(_headImageFileBytes.value));
  }

  /// 重命名
  void _rename(String newName) {
    _provider.renameUser(newName).then((value) {
      _localStorage.write(C.userName, newName);
      _refreshUserName();
    });
  }

  /// 进入房间
  void _joinRoom() {
    /// 保存设置信息
    MemoryStorage.openVideo = _controller._openVideo.value;
    MemoryStorage.openAudio = _controller._openAudio.value;
    MemoryStorage.cameraIdx = _controller._cameraIdx.value;

    /// 检查房间号
    int rid;
    try {
      rid = int.parse(_roomIdTextController.text);
    } catch (e) {
      Get.snackbar('房间号错误', '您输入的不是正确的房间号');
      return;
    }
    _roomIDFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    MemoryStorage.rid = rid;

    /// 检查密码
    if (_roomIdTextController.text != _passwordTextController.text) {
      Get.snackbar('密码错误', '您输入的不是正确的密码');
      return;
    }

    _logger.d('加入房间$rid');

    /// 获取token和房间名，跳转
    _provider.joinRoom(rid).then((value) {
      var respData = Util.getRespData(value);
      MemoryStorage.token = respData[C.token];
      MemoryStorage.roomName = respData[C.roomName];
      _logger.d('房间名:${MemoryStorage.roomName}, token:${MemoryStorage.token}');
      Get.toNamed('/room');
    });
  }
}

class HomeController extends GetxController {
  final _logger = Logger();
  final _localStorage = GetStorage();

  // 数据
  final _openVideo = MemoryStorage.openVideo.obs; // 默认关闭视频
  final _openAudio = MemoryStorage.openAudio.obs; // 默认关闭音频
  final _cameraIdx = MemoryStorage.cameraIdx.obs; // 默认后置摄像头

  // 镜头
  final _isCameraInit = false.obs;
  CameraController? cameraController;

  /// 切换本地视频开关
  void _switchOpenVideo() {
    _openVideo.value = !_openVideo.value;
    if (_openVideo.value) {
      _refreshCamera();
    }
  }

  /// 切换本地音频开关
  void _switchOpenAudio() {
    _openAudio.value = !_openAudio.value;
  }

  /// 切换前后摄
  void _switchCamera() {
    _cameraIdx.value = _cameraIdx.value == 0 ? 1 : 0;
    _refreshCamera();
  }

  /// 刷新前后摄
  void _refreshCamera() {
    cameraController = CameraController(
        MemoryStorage.cameras[_cameraIdx.value], ResolutionPreset.medium);
    _isCameraInit.value = false;
  }

  /// 构建本地镜头
  Widget _buildLocalRenderView(BuildContext context) {
    if (_openVideo.value) {
      // 需要开启视频
      if (cameraController == null) {
        _refreshCamera();
      }

      if (cameraController != null && !cameraController!.value.isInitialized) {
        cameraController?.initialize().then((_) {
          _isCameraInit.value = true;
        });
      }
    } else {
      return _buildContainer();
    }

    _logger.d('相机初始化：${cameraController?.value.isInitialized}');
    if (!_isCameraInit.value || cameraController == null) {
      return _buildContainer();
    } else {
      // logger.d('相机参数：${cameraController?.value.aspectRatio}');
      return AspectRatio(
        aspectRatio: cameraController!.value.aspectRatio,
        child: CameraPreview(cameraController!),
      );
    }
  }

  /// 构建一个空Container
  Widget _buildContainer() {
    return Container();
  }

  /// onInit 初始化
  @override
  void onInit() {
    _logger.d('HomeController onInit!!');
    super.onInit();
  }

  /// onReady onInit之后一帧，用于一些事件：dialogs、async request等
  @override
  void onReady() {
    super.onReady();
    _logger.d('HomeController onReady!!');
    _refreshCamera();
  }

  /// onClose onDelete之前，用于释放资源
  @override
  void onClose() {
    _logger.d('HomeController onClose!!');
    super.onClose();
    _isCameraInit.value = false;
    cameraController?.dispose();

    _localStorage.write(C.openVideo, _openVideo.value);
    _localStorage.write(C.openAudio, _openAudio.value);
    _localStorage.write(C.cameraIdx, _cameraIdx.value);
  }
}
