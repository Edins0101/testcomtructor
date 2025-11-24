import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/widgets/text.dart';

class ProductSpecsCard extends StatelessWidget {
  const ProductSpecsCard({
    super.key,
    required this.dimensions,
  });

  final String dimensions;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: size.width * 0.045,
                color: AppTheme.gray,
              ),
              SizedBox(width: size.width * 0.02),
              TextWidget(
                title: 'Especificaciones',
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.038,
                color: AppTheme.black,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                title: 'Dimensiones:',
                fontSize: size.width * 0.035,
                color: AppTheme.black,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.004,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.gray,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextWidget(
                  title: dimensions,
                  fontSize: size.width * 0.032,
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
