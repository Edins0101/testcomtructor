import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/modules/quotes/model/quote_detail.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';

class QuoteProductItemCardWidget extends StatelessWidget {
  const QuoteProductItemCardWidget({super.key, required this.item});

  final QuoteItemDetail item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: AppTheme.gray,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // iconito del producto
            Container(
              padding: EdgeInsets.all(size.width * 0.025),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.category_outlined,
                color: Colors.blue,
                size: size.width * 0.06,
              ),
            ),
            SizedBox(width: size.width * 0.035),

            // info principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(
                    title: item.productName,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.04,
                    color: AppTheme.black,
                  ),
                  SizedBox(height: size.height * 0.005),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.003,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.grayLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextWidget(
                          title: '\$${item.unitPrice.toStringAsFixed(2)} c/u',
                          fontSize: size.width * 0.032,
                          color: AppTheme.black,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.003,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.grayLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextWidget(
                          title: '${item.quantity} unidades',
                          fontSize: size.width * 0.032,
                          color: AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Subtotal a la derecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.004,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextWidget(
                    title: '\$${item.lineTotal.toStringAsFixed(2)}',
                    fontSize: size.width * 0.038,
                    color: AppTheme.primaryMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
