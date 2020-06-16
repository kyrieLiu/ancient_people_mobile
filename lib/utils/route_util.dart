import 'package:ancientpeoplemobile/ui/webview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

/// author Liu Yin
/// date 2020/6/11
/// Description:

class RouteUtil {
  static void toWebView(BuildContext context, String title, String url) async {
    if (context == null || url.isEmpty) return;
    if (url.endsWith('.apk')) {
      launchInBrowser(url, title: title);
    } else {
      await Navigator.of(context)
          .push(new CupertinoPageRoute(builder: (context) {
        return new WebViewScreen(title: title, url: url);
      }));
    }
  }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not lauch $url';
    }
  }
}
