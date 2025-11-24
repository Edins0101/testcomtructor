import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/modules/quotes/model/quote_response.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.quote, this.onTap});

  final QuotePriority quote;
  final VoidCallback? onTap;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'pendiente':
        return AppTheme.yellow;
      case 'approved':
      case 'aprobado':
        return AppTheme.green;
      case 'rejected':
      case 'rechazado':
        return AppTheme.red;
      default:
        return AppTheme.gray;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'approved':
        return 'Aprobada';
      case 'rejected':
        return 'Rechazada';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd MMM yyyy', 'es');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 6,
        margin: EdgeInsets.only(bottom: size.height * 0.015),
        shadowColor: AppTheme.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            // 🔵 Header azul
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.015,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryDarkest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .start,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      TitleWidget(
                        title: 'Cotización #${quote.id}',
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.042,
                      ),
                      SizedBox(height: size.height * 0.004),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: size.width * 0.032,
                            color: AppTheme.white,
                          ),
                          SizedBox(width: size.width * 0.015),
                          TextWidget(
                            title: dateFormat.format(quote.createdAt),
                            color: AppTheme.white,
                            fontSize: size.width * 0.032,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: size.width * 0.02),
                  // pill de estado
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.height * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(quote.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextWidget(
                      title: _statusLabel(quote.status),
                      color: AppTheme.white,
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        title: 'Productos',
                        fontSize: size.width * 0.035,
                        color: AppTheme.black,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.004,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryMedium,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextWidget(
                          title: '${quote.items} items',
                          fontSize: size.width * 0.032,
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.012),
                  Divider(height: 1, color: AppTheme.gray),
                  SizedBox(height: size.height * 0.012),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        title: 'Subtotal',
                        fontSize: size.width * 0.035,
                        color: AppTheme.black,
                        fontWeight: FontWeight.w500,
                      ),
                      TextWidget(
                        title: '\$${quote.total.toStringAsFixed(2)}',
                        fontSize: size.width * 0.04,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
