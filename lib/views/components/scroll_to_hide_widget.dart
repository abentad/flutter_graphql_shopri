import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHideWidget extends StatefulWidget {
  const ScrollToHideWidget({Key? key, required this.child, required this.widgetHeight, required this.controller, this.duration = const Duration(milliseconds: 200)}) : super(key: key);
  final Widget child;
  final double widgetHeight;
  final ScrollController controller;
  final Duration duration;

  @override
  _ScrollToHideWidgetState createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
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
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
    // if (widget.controller.position.pixels >= 200) {
    //   hide();
    // } else if (direction == ScrollDirection.forward) {
    //   show();
    // }
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
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: isVisible ? widget.widgetHeight : 0,
      child: Wrap(
        children: [
          widget.child,
        ],
      ),
    );
  }
}

class ScrollToScaleWidget extends StatefulWidget {
  const ScrollToScaleWidget({Key? key, required this.child, required this.controller, required this.duration}) : super(key: key);
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  @override
  _ScrollToScaleWidgetState createState() => _ScrollToScaleWidgetState();
}

class _ScrollToScaleWidgetState extends State<ScrollToScaleWidget> with TickerProviderStateMixin {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listen);
    _controller.forward();
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
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
      _controller.forward();
    }
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
      _controller.reverse();
    }
  }

  late final AnimationController _controller = AnimationController(duration: widget.duration, vsync: this);
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: Wrap(children: [widget.child]));
  }
}
