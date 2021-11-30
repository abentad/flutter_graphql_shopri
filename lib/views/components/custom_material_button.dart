import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    Key? key,
    required this.onPressed,
    required this.btnLabel,
  }) : super(key: key);

  final Function() onPressed;
  final String btnLabel;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.infinity,
      color: Colors.black,
      height: 50.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Text(btnLabel, style: const TextStyle(color: Colors.white, fontSize: 18.0)),
    );
  }
}
