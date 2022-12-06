import 'package:camera/camera.dart';
import 'package:wct/util/constant.dart';

import './util.dart';

class MemoryStorage {
  static List<CameraDescription> cameras = [];
  static String token = '';
  static String roomName = '';
  static int rid = -1;

  static bool openVideo = Util.getLocalData(C.openVideo, false); // 默认关闭视频
  static bool openAudio = Util.getLocalData(C.openAudio, false); // 默认关闭音频
  static int cameraIdx = Util.getLocalData(C.cameraIdx, 0); // 默认后置摄像头
}
