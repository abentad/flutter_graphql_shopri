// ignore: must_be_immutable
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFormFieldAuth extends StatefulWidget {
  CustomTextFormFieldAuth({
    Key? key,
    required this.controller,
    this.isObsecure = false,
    this.hasPasswordVisibilityButton = false,
    required this.keyboardType,
    required this.prefixText,
    required this.paddingRight,
    required this.onchanged,
  }) : super(key: key);

  final TextEditingController controller;
  bool isObsecure;
  final bool hasPasswordVisibilityButton;
  final TextInputType keyboardType;
  final String prefixText;
  final double paddingRight;
  final Function(String) onchanged;

  @override
  State<CustomTextFormFieldAuth> createState() => _CustomTextFormFieldStateAuth();
}

class _CustomTextFormFieldStateAuth extends State<CustomTextFormFieldAuth> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onchanged,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      cursorColor: Colors.black,
      style: const TextStyle(fontSize: 18.0),
      obscureText: widget.isObsecure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        filled: true,
        fillColor: const Color(0xfff2f2f2),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: const BorderSide(color: Color(0xfff2f2f2))),
        suffixIcon: widget.hasPasswordVisibilityButton
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isObsecure = !widget.isObsecure;
                  });
                },
                child: SizedBox(
                  child: widget.isObsecure ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                ),
              )
            : null,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 10.0, right: widget.paddingRight),
          child: Text(widget.prefixText, style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}
