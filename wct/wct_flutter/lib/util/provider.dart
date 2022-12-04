import 'package:get/get.dart';
import 'package:wct/util/constant.dart';
import 'package:get_storage/get_storage.dart';
import './constant.dart';

class Provider extends GetConnect {
  final _localStorage = GetStorage();

  Future<Response<String>> test() {
    return get('${C.server}/test/1');
  }

  Future<Response<Map>> getToken(int uid, int rid) {
    return get('${C.server}/login/token?uid=$uid&rid=$rid');
  }

  Future<Response<Map>> createUser() {
    return get('${C.server}/login/createUser');
  }

  // Future<Response<Map>> createRoom(String roomName) {
  //   return get('{C.server}/login/create/room?name=$roomName';
  // }

  Future<Response<Map>> joinRoom(int rid) {
    return get('${C.server}/login/joinRoom?rid=$rid&uid=${_localStorage.read(C.uid)}');
  }

  Future<Response<Map>> sendChat(int rid, String content) {
    return post('${C.server}/chat/send', {
      'uid': _localStorage.read(C.uid),
      'rid': rid,
      'content': content,
    });
  }

  Future<Response<Map>> listChat(int rid, int from, int to) {
    return get('${C.server}/chat/list?rid=$rid&from=$from&to=$to');
  }

// Future<Response> postUser(Map data) => post('ttp://youapi/users' data);
}

