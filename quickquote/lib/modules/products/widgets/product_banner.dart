import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';

class ProductHeaderBanner extends StatelessWidget {
  const ProductHeaderBanner({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.16,
      decoration: BoxDecoration(
        color: AppTheme.primaryDarkest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          icon,
          color: AppTheme.white,
          size: size.width * 0.18,
        ),
      ),
    );
  }
}
