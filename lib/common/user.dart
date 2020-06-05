import 'package:ancientpeoplemobile/utils/sp_util.dart';

import 'common.dart';

class User {
  static final User singleton = User._internal();

  factory User() {
    return singleton;
  }

  User._internal();

  List<String> cookie;

  String userName;

  Future<Null> getUserInfo() async {
    List<String> cookies = SPUtil.getStringList(Constants.COOKIES_KEY);
    if (cookies != null) {
      cookie = cookies;
    }
    String username = SPUtil.getString(Constants.USERNAME_KEY);
    if (username != null) {
      userName = username;
    }
  }

  void clearUserInfo() {
    cookie = null;
    userName = null;
    SPUtil.remove(Constants.COOKIES_KEY);
    SPUtil.remove(Constants.USERNAME_KEY);
  }
}
