import 'package:flutter/material.dart';
import 'package:quickquote/modules/quotes/widgets/quotes_priority.dart';
import 'package:quickquote/shared/widgets/provider_layout.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key, required this.globalKey});
  final GlobalKey globalKey;

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      keyDismiss: widget.globalKey,
      requiredStack: false,
      nameInterceptor: 'MyQuotes',
      isHomePage: false,
      showBottomNavBar: true,
      title: 'Cotizaciones guardadas',
      child: QuotesByPriorityWidget(),
    );
  }
}
