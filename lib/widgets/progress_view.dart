import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// author Liu Yin
/// date 2020/6/11
/// Description:

class ProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: new CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
