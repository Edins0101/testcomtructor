import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
      {super.key,
      this.fontSize = 20,
      this.imagePath = '',
      required this.title,
      this.fontWeight = FontWeight.w500,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.color = AppTheme.black,
      this.sizeIcon,
      this.fontFamily});

  final double? fontSize;
  final String? imagePath;
  final String title;
  final FontWeight fontWeight;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;
  final double? sizeIcon;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        imagePath != '' ? const Text('hola') : const SizedBox(),
        imagePath != '' ? const SizedBox(width: 7) : const SizedBox(),
        Text(
          title,
          maxLines: 1,
          overflow: .ellipsis,
          style: TextStyle(
              color: color,
              fontWeight: fontWeight,
              fontSize: fontSize,
              fontFamily: fontFamily),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
