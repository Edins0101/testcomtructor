import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/widgets/text.dart';

class ProductPriceStockCard extends StatelessWidget {
  const ProductPriceStockCard({
    super.key,
    required this.price,
    required this.stock,
  });

  final double price;
  final int stock;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Precio unitario
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                title: 'Precio unitario',
                fontSize: size.width * 0.036,
                color: AppTheme.black,
              ),
              TextWidget(
                title: '\$${price.toStringAsFixed(2)}',
                fontSize: size.width * 0.04,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: size.height * 0.012),
          // Stock disponible
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                title: 'Stock disponible',
                fontSize: size.width * 0.036,
                color: AppTheme.black,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.004,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextWidget(
                  title: '$stock unidades',
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
