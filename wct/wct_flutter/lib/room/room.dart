import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:volc_engine_rtc/volc_engine_rtc.dart';
import 'package:wct/home/home.dart';
import 'package:wct/room/live_view.dart';

import '../util/constant.dart';
import '../util/databus.dart';

var logger = Logger();

class RoomPage extends StatelessWidget {
  final controller = Get.put(_RoomController());
  final iconSize = 40.0;
  final iconTextScaleFactor = 1.0;

  RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    // AutoOrientation.landscapeLeftMode();
    // 旋转屏幕为横屏
    // AutoOrientation.landscapeAutoMode();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, 30.0),
        child: AppBar(
          title: Text('房间号：${MemoryStorage.rid} 房间名：${MemoryStorage.roomName}'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
            ),
            onPressed: () {
              Get.offAll(() {
                logger.d('返回主页面！');
                controller._hangUp();
                return HomePage();
              });
            },
          ),
        ),
      ),

      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.width * 0.6,
              child: Expanded(
                child: Column(
                  children: [
                    controller._buildLocalRenderView(),
                    Flex(direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Column(
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            icon: Obx(() =>
                                Icon(controller._openVideo.value
                                    ? Icons.video_call_outlined
                                    : Icons.video_call_rounded)),
                            onPressed: () => controller._switchOpenVideo(),
                          ),
                          Obx(() =>
                              Text(
                                  controller._openVideo.value ? '关闭视频' : '打开视频',
                                  textScaleFactor: iconTextScaleFactor)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            icon: Obx(() =>
                                Icon(controller._openAudio.value
                                    ? Icons.keyboard_voice_rounded
                                    : Icons.keyboard_voice_outlined)),
                            onPressed: () => controller._switchOpenAudio(),
                          ),
                          Obx(() =>
                              Text(
                                  controller._openAudio.value ? '关闭音频' : '打开音频',
                                  textScaleFactor: iconTextScaleFactor)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            icon: Obx(() =>
                                Icon(controller._isSpeakerphone.value
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_up_outlined)),
                            onPressed: () => controller._switchAudioRoute(),
                          ),
                          Obx(() =>
                              Text(
                                  controller._isSpeakerphone.value ? '使用听筒' : '使用扬声器',
                                  textScaleFactor: iconTextScaleFactor)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            icon: Obx(() =>
                                Icon(controller._cameraIdx.value == 0
                                    ? Icons.camera_alt_rounded
                                    : Icons.camera_alt_outlined)),
                            onPressed: () => controller._switchCamera(),
                          ),
                          Obx(() =>
                              Text(
                                  controller._cameraIdx.value == 0
                                      ? '换成前摄'
                                      : '换成后摄',
                                  textScaleFactor: iconTextScaleFactor)),
                        ],
                      ),
                    ],),
                    Expanded(child:
                    ListView(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              controller.users.add(null);
                            },
                            child: const Text('一个按钮更改信息')),
                      ],
                    ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(
              width: context.width * 0.4,
              child: Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        width: context.width * 0.4,
                        height: context.height * 0.8,
                        child: Obx(
                              () =>
                              ListView.builder(
                                  itemCount: controller.users.length,
                                  itemBuilder: (ctx, idx) {
                                    return controller._buildRemoteRenderView(
                                        idx);
                                  }),
                        ),
                      ),
                      Obx(
                            () =>
                            Text(
                                '实时在线人数：${(controller.users.length + 1).toString()}'),
                      ),
                    ],
                  )),
            ),
          ]),
      // 本地视频窗口+远端视频窗口
    );
  }
}

class _RoomController extends GetxController {
  var uid = 'uid';
  var rid = 'rid';
  var appId = '635511442adebe01979a1fc2'; // wct
  RTCVideo? _rtcVideo;
  RTCRoom? _rtcRoom;
  var info = 'default'.obs;

  RxList<RTCViewContext?> users = <RTCViewContext?>[].obs;

  final _videoHandler = RTCVideoEventHandler();
  final _roomHandler = RTCRoomEventHandler();
  final localStorage = GetStorage();

  Rx<RTCViewContext?> _localRenderContext =
      RTCViewContext
          .localContext(uid: '')
          .obs;

  _RoomController() {
    begin();
  }

  void begin() {
    rid = MemoryStorage.rid.toString();
    uid = localStorage.read(C.uid).toString();

    /// 获取当前SDK的版本号
    RTCVideo.getSdkVersion().then((value) {
      logger.d('sdk = $value');
    });

    logger.d('_initVideoEventHandler');
    _initVideoEventHandler();
    logger.d('_initRoomEventHandler');
    _initRoomEventHandler();
    logger.d('_initVideoAndJoinRoom');
    _initVideoAndJoinRoom();
  }

  void _initVideoEventHandler() {
    /// SDK收到第一帧远端视频解码数据后，用户收到此回调。
    _videoHandler.onFirstRemoteVideoFrameDecoded =
        (RemoteStreamKey streamKey, VideoFrameInfo videoFrameInfo) {
      logger.d('第一帧来了: ${streamKey.uid}');
      // // 已经有了当前用户的view
      // if (users.any((element) => element?.uid == streamKey.uid)) {
      //   return;
      // }
      // users.add(RTCViewContext.remoteContext(roomId: rid, uid: streamKey.uid));
    };

    /// 警告回调，详细可以看 {https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_common_defines/WarningCode.html}
    _videoHandler.onWarning = (WarningCode code) {
      logger.w('有个警示，warningCode: $code');
    };

    /// 错误回调，详细可以看 {https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_common_defines/ErrorCode.html}
    _videoHandler.onError = (ErrorCode code) {
      logger.e('发生了错误，errorCode: $code');
      Get.snackbar('error', 'errorCode: $code');
    };
  }

  void _initRoomEventHandler() {
    /// 远端主播角色用户加入房间回调。
    _roomHandler.onUserJoined = (UserInfo userInfo, int elapsed) {
      logger.d('有用户进来了: ${userInfo.uid}，elapsed: $elapsed');
      if (users.any((element) => element?.uid == userInfo.uid)) {
        // 已经有了当前用户的view
        return;
      }
      users.add(RTCViewContext.remoteContext(roomId: rid, uid: userInfo.uid));
    };

    /// 远端用户离开房间回调。
    _roomHandler.onUserLeave = (String uid, UserOfflineReason reason) {
      logger.d('有用户离开了: $uid reason: $reason');
      var rtcVideoContext = users.firstWhere((element) => element?.uid == uid);
      users.remove(rtcVideoContext);
      rtcVideoContext = null;
      _rtcVideo?.removeRemoteVideo(uid: uid, roomId: rid);
    };
  }

  void _initVideoAndJoinRoom() async {
    /// 创建引擎
    _rtcVideo = await RTCVideo.createRTCVideo(
        RTCVideoContext(appId, eventHandler: _videoHandler));
    logger.d('创建引擎: $_rtcVideo');
    if (_rtcVideo == null) {
      Get.defaultDialog(
          title: 'Fail',
          middleText: '引擎创建失败\n请先检查是否设置正确的AppId',
          confirm: ElevatedButton(
              onPressed: () {
                printInfo(info: '引擎创建失败\n请先检查是否设置正确的AppId');
                Get.back();
              },
              child: const Text('确认')));
      return;
    }

    /// 设置视频发布参数
    VideoEncoderConfig solution = VideoEncoderConfig(
      width: 360,
      height: 640,
      frameRate: 5,
      maxBitrate: -1,
      encoderPreference: EncoderPreference.maintainFrameRate,
    );
    _rtcVideo?.setMaxVideoEncoderConfig(solution);

    /// 设置本地视频渲染视图
    _localRenderContext = RTCViewContext
        .localContext(uid: uid)
        .obs;

    /// 设置摄像头
    _cameraIdx.value = localStorage.read(C.cameraIdx);
    _refreshCamera();

    /// 开启本地视频采集
    _openVideo.value = localStorage.read(C.openVideo);
    _refreshLocalVideo();

    /// 开启本地音频采集
    _openAudio.value = localStorage.read(C.openAudio);
    _refreshLocalAudio();

    /// 创建房间
    _rtcRoom = await _rtcVideo?.createRTCRoom(rid);

    /// 设置房间事件回调处理
    _rtcRoom?.setRTCRoomEventHandler(_roomHandler);

    /// 加入房间
    UserInfo userInfo = UserInfo(uid: uid);
    RoomConfig roomConfig = RoomConfig(
        isAutoPublish: true,
        isAutoSubscribeAudio: true,
        isAutoSubscribeVideo: true);
    _rtcRoom?.joinRoom(
        token: MemoryStorage.token, userInfo: userInfo, roomConfig: roomConfig);
  }

  Widget _buildLocalRenderView() {
    // return Container(height: C.bigHeight,
    //   width: C.bigWidth,color: Color.fromARGB(100, 100, 100, 100),);

    logger.d('_buildLocalRenderView: ${_localRenderContext.value != null}');
    if (_localRenderContext.value != null) {
      return SizedBox(
          height: C.bigHeight,
          width: C.bigWidth,
          child: UserLiveView(viewContext: _localRenderContext.value!));
    } else {
      return const Text('null local !!');
    }
  }

  Widget _buildRemoteRenderView(int idx) {
    // return Container(height: C.bigHeight,
    //   width: C.bigWidth,color: Color.fromARGB(200, 200, 200, 200),);

    logger.d('_buildRemoteRenderView [$idx]: ${users[idx] != null}');
    return SizedBox(
        height: C.bigHeight,
        width: C.bigWidth,
        child: UserLiveView(viewContext: users[idx]!));
  }

  final _cameraIdx = 0.obs;
  final _isSpeakerphone = true.obs;
  final _openAudio = true.obs;
  final _openVideo = true.obs;

  void _switchCamera() {
    _cameraIdx.value = _cameraIdx.value == 0 ? 1 : 0;
    _refreshCamera();
  }

  void _refreshCamera() {
    /// 设置前置/后置摄像头
    CameraId cameraId = _cameraIdx.value == 1 ? CameraId.front : CameraId.back;
    _rtcVideo?.switchCamera(cameraId);
  }

  void _switchAudioRoute() {
    _isSpeakerphone.value = !_isSpeakerphone.value;
    _refreshAudioRoute();
  }

  void _refreshAudioRoute() {
    /// 设置使用扬声器/听筒播放音频数据
    AudioRoute audioRoute =
    _isSpeakerphone.value ? AudioRoute.speakerphone : AudioRoute.earpiece;
    _rtcVideo?.setDefaultAudioRoute(audioRoute);
  }

  void _switchOpenAudio() {
    _openAudio.value = !_openAudio.value;
    _refreshLocalAudio();
  }

  void _refreshLocalAudio() {
    if (_openAudio.value) {
      /// 开启本地音频发送
      _rtcRoom?.publishStream(MediaStreamType.audio);
    } else {
      /// 关闭本地音频发送
      _rtcRoom?.unpublishStream(MediaStreamType.audio);
    }
  }

  void _switchOpenVideo() {
    _openVideo.value = !_openVideo.value;
    _refreshLocalVideo();
  }

  void _refreshLocalVideo() {
    if (_openVideo.value) {
      /// 开启视频采集
      _rtcVideo?.startVideoCapture();
    } else {
      /// 关闭视频采集
      _rtcVideo?.stopVideoCapture();
    }
  }

  @override
  void onClose() {
    super.onClose();
    _hangUp();
  }

  void _hangUp() {
    /// 离开房间
    logger.d('我离开了房间');
    _rtcRoom?.leaveRoom();
  }
}
