import 'package:flutter/material.dart';
import 'package:quickquote/modules/quotes/widgets/quote_detail.dart';
import 'package:quickquote/shared/widgets/provider_layout.dart';

class QuoteDetailPage extends StatefulWidget {
  const QuoteDetailPage({super.key, this.globalKey});
  final GlobalKey? globalKey;

  @override
  State<QuoteDetailPage> createState() => _QuoteDetailPageState();
}

class _QuoteDetailPageState extends State<QuoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      keyDismiss: widget.globalKey,
      backPageView: true,
      requiredStack: false,
      title: 'Detalle de cotización',
      child: QuoteDetailWidget(),
    );
  }
}
