import 'dart:io';

import 'package:ancientpeoplemobile/common/application.dart';
import 'package:ancientpeoplemobile/common/common.dart';
import 'package:ancientpeoplemobile/common/user.dart';
import 'package:ancientpeoplemobile/event/theme_change_event.dart';
import 'package:ancientpeoplemobile/net/dio_manager.dart';
import 'package:ancientpeoplemobile/res/colors.dart';
import 'package:ancientpeoplemobile/ui/home_screen.dart';
import 'package:ancientpeoplemobile/ui/main_screen.dart';
import 'package:ancientpeoplemobile/ui/splash_screen.dart';
import 'package:ancientpeoplemobile/utils/sp_util.dart';
import 'package:ancientpeoplemobile/utils/theme_util.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SPUtil.getInstance();

  await getTheme();

  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

Future<Null> getTheme() async {
  bool dark = SPUtil.getBool(Constants.DARK_KEY, defValue: false);
  if (!dark) {
    String themeColorKey =
        SPUtil.getString(Constants.THEME_COLOR_KEY, defVlaue: 'cyan');
    if (themeColorMap.containsKey(themeColorKey)) {
      ThemeUtils.currentThemeColor = themeColorMap[themeColorKey];
    }
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    _initAsync();
    Application.eventBus = new EventBus();
    themeData = ThemeUtils.getThemeData();
    this.registerThemeEvent();
  }

  void registerThemeEvent() {
    Application.eventBus
        .on<ThemeChangeEvent>()
        .listen((ThemeChangeEvent onData) => this.changeTheme(onData));
  }

  void changeTheme(ThemeChangeEvent onData) async {
    setState(() {
      themeData = ThemeUtils.getThemeData();
    });
  }

  void _initAsync() async {
    await User().getUserInfo();
    await DioManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: themeData,
      navigatorKey: navigatorKey,
      home: MainScreen(),
    );
  }
}
