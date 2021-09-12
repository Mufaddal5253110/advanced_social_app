import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField1 extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final IconData? icon;
  final String? initialtext;
  final bool? validity;
  final double topMargin;
  final double bottomMargin;
  final double leftMargin;
  final double rightMargin;
  final int? maxLines;
  final String? errorText;

  const CustomTextField1({
    Key? key,
    this.label,
    this.controller,
    this.icon,
    this.initialtext,
    this.validity,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.leftMargin = 0.0,
    this.rightMargin = 0.0,
    this.maxLines = 1,
    this.errorText = '',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
        bottom: bottomMargin,
        left: leftMargin,
        right: rightMargin,
      ),
      width: Get.width * 0.85,
      child: TextField(
        controller: controller!..text = initialtext!,
        decoration: InputDecoration(
          labelText: label,
          errorText: !validity! ? errorText : null,
          filled: true,
          fillColor: Colors.grey[300],
          prefixIcon: Icon(icon),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        maxLines: maxLines == -1 ? null : maxLines,
      ),
    );
  }
}
