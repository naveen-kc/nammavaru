import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final String text, fontFamily;
  double width, height, elevation;
  final VoidCallback onPressed;
  BorderRadiusGeometry? borderRadius;
  double? fontSize;

  Button(
      {Key? key,
        required this.textColor,
        required this.backgroundColor,
        required this.text,
        required this.width,
        required this.height,
        required this.onPressed,
        required this.fontFamily,
        this.borderRadius,
        required this.elevation,
        this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: onPressed,
        child: Material(
          elevation: elevation,
          color: backgroundColor,
          borderRadius: borderRadius,
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: width,
            height: height,
            child: Text(
              text,
              style: TextStyle(
                  color: textColor, fontFamily: fontFamily, fontSize: fontSize),
            ),
          ),
        ),
      ),
    );
  }
}
