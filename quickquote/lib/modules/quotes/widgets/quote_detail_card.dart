import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/modules/quotes/model/quote_detail.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';

class QuoteDetailHeaderCardWidget extends StatefulWidget {
  const QuoteDetailHeaderCardWidget({super.key, required this.quote});

  final QuoteSummary quote;

  @override
  State<QuoteDetailHeaderCardWidget> createState() => _QuoteDetailHeaderCardWidgetState();
}

class _QuoteDetailHeaderCardWidgetState extends State<QuoteDetailHeaderCardWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd MMM yyyy', 'es');

    // final createdText = DateHelper.formatLong(quote.createdAt);
    // final updatedText = DateHelper.formatLong(quote.updatedAt);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        color: AppTheme.primaryDarkest,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: size.width * 0.06,
                  color: AppTheme.white,
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: TitleWidget(
                    title: 'Cotización #${widget.quote.id}',
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05,
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * 0.015),

            // fecha creada
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.white,
                  size: size.width * 0.035,
                ),
                SizedBox(width: size.width * 0.02),
                TextWidget(
                  title: dateFormat.format(widget.quote.createdAt),
                  color: AppTheme.white,
                  fontSize: size.width * 0.035,
                ),
              ],
            ),

            SizedBox(height: size.height * 0.006),

            // última actualización
            TextWidget(
              title: 'Actualizado: ${dateFormat.format(widget.quote.updatedAt)}',
              color: AppTheme.white,
              fontSize: size.width * 0.032,
            ),
          ],
        ),
      ),
    );
  }
}
