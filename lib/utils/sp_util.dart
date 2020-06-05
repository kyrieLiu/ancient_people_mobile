import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SPUtil {
  static SPUtil _singleton;
  static SharedPreferences _prefs;
  static Lock _lock = Lock();

  static Future<SPUtil> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          var singleton = SPUtil._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  SPUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs.getBool(key) ?? defValue;
  }

  static String getString(String key, {String defVlaue = ''}) {
    if (_prefs == null) {
      return defVlaue;
    } else {
      return _prefs.getString(key) ?? defVlaue;
    }
  }

  static getStringList(String key, {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs.getStringList(key) ?? defValue;
  }

  static Future<bool> remove(String key) {
    if (_prefs == null) return null;
    return _prefs.remove(key);
  }

  static Future<bool> clear() {
    if (_prefs == null) {
      return null;
    }
    return _prefs.clear();
  }
}
