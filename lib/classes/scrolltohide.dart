import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToDideWideget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  const ScrollToDideWideget({
    Key? key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<ScrollToDideWideget> createState() => _ScrollToDideWidegetState();
}

class _ScrollToDideWidegetState extends State<ScrollToDideWideget> {
  bool isVisible = true;

  void initState() {
    super.initState();
    widget.controller.addListener(listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    }else if(direction == ScrollDirection.reverse){
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: widget.duration,
        height: isVisible ? 400 : 0,
        child: isVisible? Wrap(children: [widget.child]):const SizedBox.shrink(),
      );
}
