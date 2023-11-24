import 'dart:html';

import 'package:flutter/material.dart';

class Backdrop extends StatefulWidget {
  const Backdrop(
      {Key? key,
      required this.color,
      required this.width,
      required this.height,
      required this.selectedIndex,
      required this.previousIndex,
      required this.controller})
      : super(key: key);

  final Color color;
  final double width;
  final double height;
  final int selectedIndex;
  final int previousIndex;
  final AnimationController controller;

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop> {
// 这是什么？
  double get _translateX => Tween<double>(
          begin: widget.previousIndex * widget.width,
          end: widget.selectedIndex * widget.width)
      // 创建一个动画
      .animate(CurvedAnimation(
          parent: widget.controller, curve: Curves.easeInOutBack))
      .value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: ((context, child) => Container(
              width: widget.width,
              height: widget.height,
              transform: Matrix4.translationValues(_translateX, 0, 0),
              transformAlignment: Alignment.center,
              decoration:
                  BoxDecoration(color: widget.color, shape: BoxShape.circle),
            )));
  }
}
