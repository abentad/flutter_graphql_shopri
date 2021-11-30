import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  const RefreshWidget({Key? key, required this.onrefresh, required this.child}) : super(key: key);
  final Future<void> Function() onrefresh;
  final Widget child;
  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onrefresh,
      child: widget.child,
    );
  }
}
