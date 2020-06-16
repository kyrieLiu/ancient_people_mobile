import 'package:flutter/material.dart';

/// author Liu Yin
/// date 2020/6/16
/// Description:

class LikeButtonWidget extends StatefulWidget {
  bool isLike = false;
  Function onClick;

  LikeButtonWidget({Key key, this.isLike, this.onClick}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LikeButtonWidgetState();
  }
}

class LikeButtonWidgetState extends State<LikeButtonWidget>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  double size = 24;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    animation = Tween(begin: size, end: size * 0.5).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: LikeAnimation(
        controller: controller,
        animation: animation,
        isLike: widget.isLike,
        onClick: widget.onClick,
      ),
    );
  }
}

class LikeAnimation extends AnimatedWidget implements StatefulWidget {
  AnimationController controller;
  Animation animation;
  Function onClick;
  bool isLike = false;

  LikeAnimation({this.controller, this.animation, this.isLike, this.onClick})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        isLike ? Icons.favorite : Icons.favorite_border,
        size: animation.value,
        color: isLike ? Colors.red : Colors.grey[600],
      ),
      onTapDown: (dragDownDetails) {
        controller.forward();
      },
      onTapUp: (drawDownDetails) {
        Future.delayed(Duration(milliseconds: 100), () {
          controller.reverse();
          onClick();
        });
      },
    );
  }
}
