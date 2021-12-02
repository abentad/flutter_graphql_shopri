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

class CustomProductTextFormField extends StatelessWidget {
  const CustomProductTextFormField({Key? key, required this.size, required this.label, required this.controller, this.maxlines = 1}) : super(key: key);
  final Size size;
  final String label;
  final int maxlines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.02),
          Text(label, style: const TextStyle(fontSize: 16.0)),
          SizedBox(height: size.height * 0.008),
          TextFormField(
            maxLines: maxlines,
            controller: controller,
            cursorColor: Colors.black,
            style: const TextStyle(fontSize: 18.0),
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.grey.shade300)),
            ),
          ),
        ],
      ),
    );
  }
}
