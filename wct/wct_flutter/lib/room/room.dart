import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:volc_engine_rtc/volc_engine_rtc.dart';
import 'package:wct/home/home.dart';
import 'package:wct/room/live_view.dart';

import '../util/constant.dart';
import '../util/databus.dart';
import '../util/model.dart';
import '../util/provider.dart';
import '../util/util.dart';

class RoomPage extends StatelessWidget {
  final logger = Logger();
  final _controller = Get.put(_RoomController());
  final Provider _provider = Provider();

  // 页面参数
  static const _iconSize = 30.0;
  static const _iconTextScaleFactor = 1.0;

  // 页面索引
  final _pageIdx = 0.obs;
  final _sidePageIdx = 0.obs;

  // 聊天
  final FocusNode _chatFocusNode = FocusNode();
  final TextEditingController _chatTextController =
      TextEditingController(text: '');

  RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 旋转屏幕为横屏
    // AutoOrientation.landscapeAutoMode();

    return Scaffold(
        appBar: _buildAppBar(context),
        body: Obx(() {
          return _pageIdx.value == 0
              ? _buildDetailPage(context)
              : _buildFullScreenPage(context);
        }));
  }

  /// 构建AppBar
  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(context.width, 30.0),
      child: AppBar(
        title: Text('房间号：${MemoryStorage.rid} 房间名：${MemoryStorage.roomName}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
          onPressed: () {
            if (_pageIdx.value == 0) {
              Get.offAll(() {
                logger.d('返回主页面！');
                _controller._hangUp();
                return HomePage();
              });
            } else {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
              _pageIdx.value = 0;
            }
          },
        ),
      ),
    );
  }

  /// 构建详情页
  Widget _buildDetailPage(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeftPage(context),
          _buildRightPage(context),
        ]);
  }

  /// 构建页面右侧：切换按钮+视频列表/聊天内容+实时人数
  SizedBox _buildRightPage(BuildContext context) {
    return SizedBox(
      width: context.width * 0.25,
      child: Expanded(
          child: Column(
        children: [
          _buildSwitchSidePageButton(),
          Expanded(
            child: Obx(
              () => _sidePageIdx.value == 0
                  ? _buildRemoteRenderViewList()
                  : _buildChatList(context),
            ),
          ),
          Obx(
            () => Text('实时在线人数：${_controller.users.length}'),
          ),
        ],
      )),
    );
  }

  /// 右侧页面切换：视频/聊天
  Row _buildSwitchSidePageButton() {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              _sidePageIdx.value = 0;
            },
            child: const Text('视频')),
        TextButton(
            onPressed: () {
              _sidePageIdx.value = 1;
            },
            child: const Text('聊天')),
      ],
    );
  }

  /// 构建页面左侧：视频播放+按钮列表
  Widget _buildLeftPage(BuildContext context) {
    return SizedBox(
      width: context.width * 0.65,
      child: Column(
        children: [
          Obx(() => Expanded(
              child: Center(child: _controller._buildVideoPlayerView()))),
          _buildButtonRow(),
        ],
      ),
    );
  }

  /// 构建远程视频渲染列表
  ListView _buildRemoteRenderViewList() {
    return ListView.builder(
        itemCount: _controller.users.length,
        itemBuilder: (ctx, idx) {
          return _controller._buildRemoteRenderView(idx);
        });
  }

  /// 构建按钮列表
  Flex _buildButtonRow() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            IconButton(
              iconSize: _iconSize,
              icon: Obx(() => Icon(_controller._openVideo.value
                  ? Icons.video_call_outlined
                  : Icons.video_call_rounded)),
              onPressed: () => _controller._switchOpenVideo(),
            ),
            Obx(() => Text(_controller._openVideo.value ? '关闭视频' : '打开视频',
                textScaleFactor: _iconTextScaleFactor)),
          ],
        ),
        Column(
          children: [
            IconButton(
              iconSize: _iconSize,
              icon: Obx(() => Icon(_controller._openAudio.value
                  ? Icons.keyboard_voice_outlined
                  : Icons.keyboard_voice_rounded)),
              onPressed: () => _controller._switchOpenAudio(),
            ),
            Obx(() => Text(_controller._openAudio.value ? '关闭音频' : '打开音频',
                textScaleFactor: _iconTextScaleFactor)),
          ],
        ),
        Column(
          children: [
            IconButton(
              iconSize: _iconSize,
              icon: Obx(() => Icon(_controller._isSpeakerphone.value
                  ? Icons.volume_up_outlined
                  : Icons.volume_up_rounded)),
              onPressed: () => _controller._switchAudioRoute(),
            ),
            Obx(() => Text(_controller._isSpeakerphone.value ? '使用听筒' : '使用扬声器',
                textScaleFactor: _iconTextScaleFactor)),
          ],
        ),
        Column(
          children: [
            IconButton(
              iconSize: _iconSize,
              icon: Obx(() => Icon(_controller._cameraIdx.value == 0
                  ? Icons.camera_alt_outlined
                  : Icons.camera_alt_rounded)),
              onPressed: () => _controller._switchCamera(),
            ),
            Obx(() => Text(_controller._cameraIdx.value == 0 ? '换成前摄' : '换成后摄',
                textScaleFactor: _iconTextScaleFactor)),
          ],
        ),
        Column(
          children: [
            IconButton(
              iconSize: _iconSize,
              icon: const Icon(Icons.screenshot_monitor_rounded),
              onPressed: () {
                _pageIdx.value = 1;
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: []);
              },
            ),
            const Text('全屏'),
          ],
        ),
      ],
    );
  }

  /// 构建聊天内容列表
  Widget _buildChatList(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Expanded(
            child: ListView.builder(
                itemCount: _controller.chatList.length,
                itemBuilder: (ctx, idx) {
                  var chatVO = _controller.chatList[idx];
                  return Text('${chatVO.uid} : ${chatVO.content}');
                }),
          ),
        ),
        _buildChatButton(),
      ],
    );
  }

  /// 构建发送聊天按钮
  ElevatedButton _buildChatButton() {
    return ElevatedButton(
        onPressed: () {
          Get.defaultDialog(
            onConfirm: () {
              _provider
                  .sendChat(MemoryStorage.rid, _chatTextController.text)
                  .then((value) {
                _chatTextController.text = '';
              });
              logger.d('发出聊天：${_chatTextController.text}');
              Get.back();
            },
            onCancel: () {
              _chatTextController.text = '';
            },
            title: '发出一句聊天吧',
            content: TextField(
              focusNode: _chatFocusNode,
              controller: _chatTextController,
              decoration: const InputDecoration(
                  floatingLabelStyle: TextStyle(fontSize: 14),
                  labelStyle: TextStyle(fontSize: 12)),
            ),
          );
        },
        child: const Text('发出聊天'));
  }

  /// 构建全屏页面
  Widget _buildFullScreenPage(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.width,
          height: context.height,
          color: const Color.fromRGBO(0, 0, 0, 1),
        ),
        Obx(() => SizedBox(
            height: context.height,
            child: Center(child: _controller._buildVideoPlayerView()))),
        Obx(() => ListView.builder(
            itemCount: _controller.latestChatList.length,
            itemBuilder: (ctx, idx) {
              var record = _controller.latestChatList[idx];
              return Text(
                '${record.uid}: ${record.content}',
                style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              );
            })),
      ],
    );
  }
}

class _RoomController extends GetxController {
  final logger = Logger();
  final localStorage = GetStorage();
  final Provider provider = Provider();

  // RTC
  var uid = 'uid';
  var rid = 'rid';
  final appId = '635511442adebe01979a1fc2'; // wct
  RTCVideo? _rtcVideo;
  RTCRoom? _rtcRoom;
  Rx<RTCViewContext?> _localRenderContext =
      RTCViewContext.localContext(uid: '').obs;
  final RxList<RTCViewContext?> users = <RTCViewContext?>[].obs;
  final _videoHandler = RTCVideoEventHandler();
  final _roomHandler = RTCRoomEventHandler();

  // 聊天
  RxList<ChatVO> chatList = <ChatVO>[].obs;
  RxList<ChatVO> latestChatList = <ChatVO>[].obs;

  // 设置
  final _cameraIdx = 0.obs;
  final _isSpeakerphone = true.obs;
  final _openAudio = true.obs;
  final _openVideo = true.obs;

  // 定时器
  late Timer chatListTimer;
  late Timer latestChatListTimer;

  // 视频播放
  VideoPlayerController? _videoPlayerController;
  final _isVideoPlayerInit = false.obs;

  _RoomController() {
    _initRTC();
    _initTimer();
  }

  /// 初始化RTC
  void _initRTC() {
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

  /// 初始化定时器
  void _initTimer() {
    chatListTimer = Timer.periodic(const Duration(seconds: 3), (thisTimer) {
      int from =
          chatList.isEmpty ? 0 : (chatList[chatList.length - 1].time + 1);
      int to = DateTime.now().millisecondsSinceEpoch + 100000000000;
      // logger.d('获取最新聊天消息 from $from to $to');
      provider.listChat(int.parse(rid), from, to).then((value) {
        var respData = Util.getRespData(value);
        for (var e in respData) {
          var chatVO = ChatVO();
          chatVO.content = e['content'];
          chatVO.id = e[C.id];
          chatVO.uid = e[C.uid];
          chatVO.time = e['time'];
          chatList.add(chatVO);
          latestChatList.add(chatVO);
        }
      });
    });

    latestChatListTimer =
        Timer.periodic(const Duration(seconds: 3), (thisTimer) {
      // 10s后消失
      latestChatList.removeWhere((element) =>
          element.time < DateTime.now().millisecondsSinceEpoch - 10000);
    });
  }

  /// 初始化视频事件回调
  void _initVideoEventHandler() {
    /// SDK收到第一帧远端视频解码数据后，用户收到此回调。
    _videoHandler.onFirstRemoteVideoFrameDecoded =
        (RemoteStreamKey streamKey, VideoFrameInfo videoFrameInfo) {
      logger.d('第一帧来了: ${streamKey.uid}');
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

    _videoHandler.onAudioDeviceWarning = (String s, AudioDeviceType a, MediaDeviceWarning m) {
      logger.w('$s $a  $m');
    };
  }

  /// 初始化房间事件回调
  void _initRoomEventHandler() {
    /// 远端主播角色用户加入房间回调
    _roomHandler.onUserJoined = (UserInfo userInfo, int elapsed) {
      logger.d('有用户进来了: ${userInfo.uid}，elapsed: $elapsed');
      if (users.any((element) => element?.uid == userInfo.uid)) {
        // 已经有了当前用户的view
        return;
      }
      users.add(RTCViewContext.remoteContext(roomId: rid, uid: userInfo.uid));
    };

    /// 远端用户离开房间回调
    _roomHandler.onUserLeave = (String uid, UserOfflineReason reason) {
      logger.d('有用户离开了: $uid reason: $reason');
      var rtcVideoContext = users.firstWhere((element) => element?.uid == uid);
      users.remove(rtcVideoContext);
      rtcVideoContext = null;
      _rtcVideo?.removeRemoteVideo(uid: uid, roomId: rid);
    };
  }

  /// 初始化引擎、加入房间
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

    // 设置音频场景
    _rtcVideo?.setAudioScenario(AudioScenario.communication);

    /// 设置本地视频渲染视图
    _localRenderContext = RTCViewContext.localContext(uid: uid).obs;

    /// 设置摄像头
    _cameraIdx.value = MemoryStorage.cameraIdx;
    _refreshCamera();

    /// 开启本地视频采集
    _openVideo.value = MemoryStorage.openVideo;
    _refreshLocalVideo();

    /// 开启本地音频采集
    _openAudio.value = MemoryStorage.openAudio;
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

    // 把自己也加入到实时视频渲染列表中
    users.add(_localRenderContext.value);
  }

  /// 构建视频播放Widget
  Widget _buildVideoPlayerView() {
    if (_videoPlayerController == null) {
      _videoPlayerController = VideoPlayerController.network(
          'https://tmp-yunzen.oss-cn-shanghai.aliyuncs.com/$rid.mp4');
      logger.d('视频地址${_videoPlayerController?.dataSource}');
    }

    if (!_isVideoPlayerInit.value) {
      _videoPlayerController?.initialize().then((_) {
        logger.d('初始化了视频 ${_videoPlayerController?.dataSource}');
        _isVideoPlayerInit.value = true;
        // 确保在初始化视频后显示第一帧，直至在按下播放按钮。
      });
    }

    if (_videoPlayerController != null && _isVideoPlayerInit.value) {
      _videoPlayerController?.setLooping(true);
      var duration = _videoPlayerController?.value.duration;
      _videoPlayerController?.seekTo(Duration(
          milliseconds: DateTime.now().millisecondsSinceEpoch %
              duration!.inMilliseconds));
      _videoPlayerController?.play();
      logger.d(
          '持续$duration, 从${_videoPlayerController?.value.position}开始，循环${_videoPlayerController?.value.isLooping}');
      return AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio - 0.1,
        child: VideoPlayer(_videoPlayerController!),
      );
    } else {
      return const Text("没有要播放的视频");
    }
  }

  /// 构建远程渲染视图
  Widget _buildRemoteRenderView(int idx) {
    logger.d('_buildRemoteRenderView [$idx]: ${users[idx] != null}');
    return SizedBox(
        height: 180,
        // width: 250,
        child: UserLiveView(viewContext: users[idx]!));
  }

  /// 切换前后摄
  void _switchCamera() {
    _cameraIdx.value = _cameraIdx.value == 0 ? 1 : 0;
    logger.d('使用${_cameraIdx.value == 0 ? '后置' : '前置'}');
    _refreshCamera();
  }

  /// 刷新前后摄
  void _refreshCamera() {
    /// 设置前置/后置摄像头
    CameraId cameraId = _cameraIdx.value == 1 ? CameraId.front : CameraId.back;
    _rtcVideo?.switchCamera(cameraId);
  }

  /// 切换扬声器/听筒
  void _switchAudioRoute() {
    _isSpeakerphone.value = !_isSpeakerphone.value;
    logger.d('使用${_isSpeakerphone.value ? '扬声器' : '听筒'}');
    _refreshAudioRoute();
  }

  /// 刷新扬声器/听筒
  void _refreshAudioRoute() {
    /// 设置使用扬声器/听筒播放音频数据
    AudioRoute audioRoute =
        _isSpeakerphone.value ? AudioRoute.speakerphone : AudioRoute.earpiece;
    _rtcVideo?.setAudioRoute(audioRoute);
  }

  /// 切换本地音频开关
  void _switchOpenAudio() {
    _openAudio.value = !_openAudio.value;
    logger.d('${_openAudio.value ? '打开' : '关闭'}本地音频');
    _refreshLocalAudio();
  }

  /// 刷新本地音频开关
  void _refreshLocalAudio() {
    if (_openAudio.value) {
      /// 开启本地音频发送
      _rtcRoom?.publishStream(MediaStreamType.audio);
      _rtcVideo?.startAudioCapture();
    } else {
      /// 关闭本地音频发送
      _rtcRoom?.unpublishStream(MediaStreamType.audio);
      _rtcVideo?.stopAudioCapture();
    }
  }

  /// 切换本地视频开关
  void _switchOpenVideo() {
    _openVideo.value = !_openVideo.value;
    logger.d('${_openAudio.value ? '打开' : '关闭'}本地视频');
    _refreshLocalVideo();
  }

  /// 刷新本地视频开关
  void _refreshLocalVideo() {
    if (_openVideo.value) {
      /// 开启视频采集
      _rtcVideo?.startVideoCapture();
    } else {
      /// 关闭视频采集
      _rtcVideo?.stopVideoCapture();
    }
  }

  /// 开始屏幕共享
  void _enableScreenShare() {
    logger.d('开始屏幕共享');

    _rtcVideo?.startScreenCapture(ScreenMediaType.videoAndAudio).then((value) {
      logger.d('屏幕共享回调');
      _rtcRoom?.publishScreen(MediaStreamType.both);
    });
  }

  @override
  void onClose() {
    super.onClose();
    _hangUp();
  }

  /// 离开房间
  void _hangUp() {
    logger.d('我离开了房间');
    _rtcRoom?.leaveRoom();
    chatListTimer.cancel();
    latestChatListTimer.cancel();
    _videoPlayerController?.dispose();
  }
}
