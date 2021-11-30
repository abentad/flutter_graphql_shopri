import 'package:flutter/material.dart';

class HomeScreenCustomAnimatedRoute extends PageRouteBuilder {
  final Widget enterWidget;

  HomeScreenCustomAnimatedRoute({required this.enterWidget})
      : super(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) => enterWidget,
          // transitionDuration: const Duration(milliseconds: 1500),
          transitionDuration: const Duration(milliseconds: 300),
          // reverseTransitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn, reverseCurve: Curves.fastOutSlowIn);
            return ScaleTransition(alignment: const Alignment(0.0, 0.87), scale: animation, child: child);
          },
        );
}
