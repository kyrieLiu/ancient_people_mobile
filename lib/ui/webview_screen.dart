import 'package:ancientpeoplemobile/utils/route_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

/// author Liu Yin
/// date 2020/6/11
/// Description: WebView加载网页

class WebViewScreen extends StatefulWidget {
  String title;
  String url;

  WebViewScreen({Key key, @required this.title, @required this.url})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new WebViewScreenState();
  }
}

class WebViewScreenState extends State<WebViewScreen> {
  bool isLoad = true;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state) =>
    {
      if (state.type == WebViewState.finishLoad)
        {
          setState(() {
            isLoad = true;
          })
        }
      else
        if (state.type == WebViewState.startLoad)
          {
            setState(() {
              isLoad = true;
            })
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: new AppBar(
        elevation: 0.4,
        title: new Text(widget.title),
        bottom: new PreferredSize(
          child: SizedBox(
            height: 2,
            child: isLoad ? new LinearProgressIndicator() : Container(),
          ),
          preferredSize: Size.fromHeight(2),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.language,
                size: 30,
              ),
              onPressed: () {
                RouteUtil.launchInBrowser(widget.url, title: widget.title);
              }
          ),
          IconButton(
            icon: Icon(Icons.share, size: 20,),
            onPressed: () {
              Share.share('${widget.title} : ${widget.url}');
            },
          )
        ],
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
      hidden: true,
    );
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}
