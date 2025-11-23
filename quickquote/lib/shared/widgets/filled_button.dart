import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';

class FilledButtonWidget extends StatefulWidget {
  final void Function()? onPressed;
  final Color? color;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? textButtonColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String? fontFamily;

  const FilledButtonWidget({
    super.key,
    this.onPressed,
    this.color,
    required this.text,
    this.width = 2,
    this.height = 55,
    this.borderRadius = 20,
    this.textButtonColor,
    this.fontWeight = FontWeight.w400,
    this.fontSize,
    this.fontFamily,
  });

  @override
  State<FilledButtonWidget> createState() => _FilledButtonWidgetState();
}

class _FilledButtonWidgetState extends State<FilledButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all<Size>(Size(150, widget.height!)),
        backgroundColor: WidgetStatePropertyAll(widget.color),
        shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius!)))),
      ),
      onPressed: widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyle(
            color: widget.textButtonColor ?? AppTheme.white,
            fontWeight: widget.fontWeight,
            fontFamily: widget.fontFamily,
            fontSize: widget.fontSize ?? 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}
