import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volc_engine_rtc/volc_engine_rtc.dart';
import 'package:wct/room/live_view.dart';

class RoomPage extends StatelessWidget {
  final _RoomController controller = Get.put(_RoomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("加入房间")),
        body: Column(children: [
          ElevatedButton(onPressed: () {}, child: const Text("create")),
          ElevatedButton(onPressed: () {}, child: const Text("join")),

          controller._buildRenderView(),
          SizedBox(
            height: 100,
            width: 200,
            child: Text("default"),
          )
          // Obx(() => Text("${controller._intent}")),
        ])
        // 本地视频窗口+远端视频窗口
        );
  }
}

class _RoomController extends GetxController {
  var uid = "uid";
  var rid = "rid";
  var appId = "635511442adebe01979a1fc2"; // wct
  var token =
      "001635511442adebe01979a1fc2PAAl5CgDgRFVYwFMXmMDAHJpZAMAdWlkBgAAAAFMXmMBAAFMXmMCAAFMXmMDAAFMXmMEAAFMXmMFAAFMXmMgAFCBA006/tL5FMgGii2LP5gMNNWJGQHaMIycgx9fqF96";
  var openVedio = false.obs;
  var openAudio = false.obs;
  RTCVideo? _rtcVideo;
  RTCRoom? _rtcRoom;
  // Set<String> uids = {};
  // List<String> uids = [];
  List<RTCViewContext?> users = [];

  final _videoHandler = RTCVideoEventHandler();
  final _roomHandler = RTCRoomEventHandler();

  RTCViewContext? _localRenderContext;

  _RoomController() {
    begin();
  }

  void begin() {
    _initVideoAndJoinRoom();
  }

  void _requestPermission() async {
    await [Permission.camera, Permission.microphone].request();

    /// 获取当前SDK的版本号
    RTCVideo.getSdkVersion().then((value) {
      print("sdk==============");
      print(value?.toString());
    });
  }

  void _initVideoEventHandler() {
    /// SDK收到第一帧远端视频解码数据后，用户收到此回调。
    _videoHandler.onFirstRemoteVideoFrameDecoded =
        (RemoteStreamKey streamKey, VideoFrameInfo videoFrameInfo) {
      debugPrint('onFirstRemoteVideoFrameDecoded: ${streamKey.uid}');
      // if (uids.contains(streamKey.uid)) {
      //   return;
      // }
      // 已经有了当前用户的view
      if (users.any((element) => element.uid == streamKey.uid)) {
        return;
      }

      users.add(RTCViewContext.remoteContext(roomId: rid, uid: streamKey.uid));
    };

    /// 警告回调，详细可以看 {https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_common_defines/WarningCode.html}
    _videoHandler.onWarning = (WarningCode code) {
      debugPrint('warningCode: $code');
    };

    /// 错误回调，详细可以看 {https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_common_defines/ErrorCode.html}
    _videoHandler.onError = (ErrorCode code) {
      debugPrint('errorCode: $code');
      Get.snackbar('error', 'errorCode: $code');
    };
  }

  void _initRoomEventHandler() {
    /// 远端主播角色用户加入房间回调。
    _roomHandler.onUserJoined = (UserInfo userInfo, int elapsed) {
      debugPrint('onUserJoined: ${userInfo.uid}');
    };

    /// 远端用户离开房间回调。
    _roomHandler.onUserLeave = (String uid, UserOfflineReason reason) {
      debugPrint('onUserLeave: $uid reason: $reason');
      var rtcVideoContext = users.firstWhere((element) => element?.uid == uid);
      users.remove(rtcVideoContext);
      rtcVideoContext = null;
      _rtcVideo?.removeRemoteVideo(uid: uid, roomId: rid);
    };
  }

  void _initVideoAndJoinRoom() async {
    /// 创建引擎
    print("创建引擎");
    _rtcVideo = await RTCVideo.createRTCVideo(
        RTCVideoContext(appId, eventHandler: _videoHandler));
    print(_rtcVideo);
    if (_rtcVideo == null) {
      Get.defaultDialog(
          title: "Fail",
          middleText: "引擎创建失败\n请先检查是否设置正确的AppId",
          confirm: ElevatedButton(
              onPressed: () {
                printInfo(info: "引擎创建失败\n请先检查是否设置正确的AppId");
                Get.back();
              },
              child: const Text("确认")));
      return;
    }

    /// 设置视频发布参数
    VideoEncoderConfig solution = VideoEncoderConfig(
      width: 360,
      height: 640,
      frameRate: 15,
      maxBitrate: 800,
      encoderPreference: EncoderPreference.maintainFrameRate,
    );
    _rtcVideo?.setMaxVideoEncoderConfig(solution);

    /// 设置本地视频渲染视图
    _localRenderContext = RTCViewContext.localContext(uid: uid);

    /// 开启本地视频采集
    _rtcVideo?.startVideoCapture();

    /// 开启本地音频采集
    _rtcVideo?.startAudioCapture();

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
        token: token, userInfo: userInfo, roomConfig: roomConfig);
  }

  _buildRenderView() {
    print("================================");
    print(_localRenderContext == null);
    if (_localRenderContext != null) {
      return SizedBox(
          height: height,
          width: width,
          child: UserLiveView(viewContext: _localRenderContext!));
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: Text("null!!!!!!!!!!!!!!!!!!!!!!!!!!!11"),
      );
    }
  }

  var height = 200.0;
  var width = 300.0;
}
