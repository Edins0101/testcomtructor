import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';

class QuoteSummaryCardWidget extends StatelessWidget {
  const QuoteSummaryCardWidget({
    super.key,
    required this.subtotal,
    required this.ivaPercent,
    required this.ivaAmount,
    required this.total,
  });

  final double subtotal;
  final double ivaPercent; // 0.13
  final double ivaAmount;
  final double total;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ivaLabel = (ivaPercent * 100).toStringAsFixed(0); // "13"

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: AppTheme.gray,
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(
              title: 'Resumen',
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
            SizedBox(height: size.height * 0.015),

            _row('Subtotal', '\$${subtotal.toStringAsFixed(2)}', size),
            SizedBox(height: size.height * 0.006),
            _row('IVA ($ivaLabel%)', '\$${ivaAmount.toStringAsFixed(2)}', size),

            SizedBox(height: size.height * 0.012),
            Divider(color: AppTheme.gray),
            SizedBox(height: size.height * 0.012),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  title: 'Total',
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
                TextWidget(
                  title: '\$${total.toStringAsFixed(2)}',
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          title: label,
          fontSize: size.width * 0.035,
          color: AppTheme.black,
        ),
        TextWidget(
          title: value,
          fontSize: size.width * 0.035,
          color: AppTheme.black,
        ),
      ],
    );
  }
}
