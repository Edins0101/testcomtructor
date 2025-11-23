import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final String? fontFamily;
  final bool underline;
  final bool isLetterSpacing;

  const TextWidget(
      {super.key,
      required this.title,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.underline = false,
      this.fontFamily,
      this.isLetterSpacing = false});

  @override
  Widget build(BuildContext context) {
    return Text(
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        maxLines: 4,
        textAlign: textAlign,
        title,
        style: TextStyle(
          color: color ?? AppTheme.black,
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight ?? FontWeight.bold,
          decoration: underline ? TextDecoration.underline : null,
          decorationColor: color,
          letterSpacing: isLetterSpacing ? 2 : null,
        ));
  }
}
