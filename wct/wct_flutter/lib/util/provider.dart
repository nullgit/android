import 'package:get/get.dart';
import 'package:wct/util/constant.dart';

class LoginProvider extends GetConnect {
  Future<Response<String>> test() {
    return get("${C.server}/test/1");
  }

  Future<Response<Map>> getToken(int uid, int rid) {
    return get("${C.server}/login/token?uid=$uid&rid=$rid");
  }

  Future<Response<Map>> createUser() {
    return get("${C.server}/login/create/user");
  }

  Future<Response<Map>> createRoom(String roomName) {
    return get("${C.server}/login/create/room?name=$roomName");
  }
// Future<Response> postUser(Map data) => post("http://youapi/users", data);
}

class ChatProvider extends GetConnect {

}
