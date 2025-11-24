import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/modules/products/widgets/quantity_selector.dart';
import 'package:quickquote/shared/widgets/text.dart';

class ProductQuantitySection extends StatelessWidget {
  const ProductQuantitySection({
    super.key,
    required this.quantity,
    required this.subtotal,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final double subtotal;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gray,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            title: 'Cantidad para cotizar',
            fontSize: size.width * 0.038,
            color: AppTheme.black,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: size.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              QuantitySelector(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.035,
                  vertical: size.height * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      title: 'Subtotal',
                      fontSize: size.width * 0.03,
                      color: AppTheme.black,
                    ),
                    TextWidget(
                      title: '\$${subtotal.toStringAsFixed(2)}',
                      fontSize: size.width * 0.04,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
