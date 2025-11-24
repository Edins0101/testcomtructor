import 'package:flutter/material.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/modules/quotes/model/quote_response.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';
import 'package:quickquote/modules/quotes/widgets/quote_card.dart';

class ProjectQuotesSection extends StatelessWidget {
  const ProjectQuotesSection({
    super.key,
    required this.group,
    this.onTapQuote,
  });

  final QuoteProjectGroup group;
  final void Function(QuotePriority quote)? onTapQuote;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de proyecto
        Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.01,
            right: size.width * 0.01,
            bottom: size.height * 0.005,
            top: size.height * 0.015,
          ),
          child: Row(
            children: [
              Icon(
                Icons.business_outlined,
                size: size.width * 0.045,
                color: Colors.blueGrey,
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleWidget(
                      title: group.projectName,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                    if (group.projectId == null)
                      TextWidget(
                        title: 'Sin proyecto asociado',
                        fontSize: size.width * 0.03,
                        color: AppTheme.gray,
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.004,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextWidget(
                  title: '${group.quotes.length} cotizaciones',
                  fontSize: size.width * 0.03,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
    
        // Lista de cards de ese proyecto
        ...group.quotes.map(
          (q) => QuoteCard(
            quote: q,
            onTap: onTapQuote != null ? () => onTapQuote!(q) : null,
          ),
        ),
      ],
    );
  }
}
