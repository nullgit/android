import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';

import 'constant.dart';

class Util {
  static final localStorage = GetStorage();

  static getRespData(Response r) {
    return r.body[C.respData];
  }

  static getLocalData(String key, Object defaultData) {
    if (!localStorage.hasData(key)) {
      localStorage.write(key, defaultData);
    }
    return localStorage.read(key);
  }
}
