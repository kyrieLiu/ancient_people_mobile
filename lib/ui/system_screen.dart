import 'package:ancientpeoplemobile/ui/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';

/// author Liu Yin
/// date 2020/6/16
/// Description:

class SystemScreen extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return SystemScreenState();
  }
}

class SystemScreenState extends BaseWidgetState<SystemScreen> {
  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(""));
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: Text("体系"),
    );
  }

  @override
  void onClickErrorWidget() {
    // TODO: implement onClickErrorWidget
  }
}
