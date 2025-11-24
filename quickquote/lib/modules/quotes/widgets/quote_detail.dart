import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/modules/quotes/model/quote_detail.dart';
import 'package:quickquote/modules/quotes/model/quote_response.dart';
import 'package:quickquote/modules/quotes/services/quote_service.dart';
import 'package:quickquote/modules/quotes/widgets/quote_detail_card.dart';
import 'package:quickquote/modules/quotes/widgets/quote_items_card.dart';
import 'package:quickquote/modules/quotes/widgets/quote_sumary_card.dart';
import 'package:quickquote/shared/providers/quote_provider.dart';
import 'package:quickquote/shared/widgets/text.dart';

class QuoteDetailWidget extends StatefulWidget {
  const QuoteDetailWidget({super.key});


  @override
  State<QuoteDetailWidget> createState() => _QuoteDetailWidgetState();
}

class _QuoteDetailWidgetState extends State<QuoteDetailWidget> {
  final QuoteService _quoteService = QuoteService();

  QuoteDetailData? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuoteDetail();
    });
  }

  Future<void> _loadQuoteDetail() async {
    final qp = Provider.of<QuoteProvider>(context, listen: false);
    final QuotePriority? quote = qp.selectedQuote;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final resp = await _quoteService.getQuoteDetail(context, quote!.id);

    if (!mounted) return;

    if (!resp.error && resp.data != null) {
      setState(() {
        _detail = resp.data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _error = resp.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // 🔹 1. Loading
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 🔹 2. Error
    if (_error != null) {
      return Center(
        child: TextWidget(
          title: _error!,
          color: Colors.red,
          fontSize: size.width * 0.04,
        ),
      );
    }

    // 🔹 3. Sin datos (por si acaso)
    final detail = _detail;
    if (detail == null) {
      return Center(
        child: TextWidget(
          title: 'No hay información disponible.',
          color: AppTheme.black,
          fontSize: size.width * 0.04,
        ),
      );
    }

    // 🔹 4. Ya tengo datos, ahora sí puedo usarlos sin "!"
    final double subtotal = detail.quote.total;
    const double ivaPercent = 0.13;
    final double iva = subtotal * ivaPercent;
    final double total = subtotal + iva;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuoteDetailHeaderCardWidget(quote: detail.quote),

          SizedBox(height: size.height * 0.025),

          TextWidget(
            title: 'Productos cotizados',
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),

          SizedBox(height: size.height * 0.012),

          ...detail.items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.012),
              child: QuoteProductItemCardWidget(item: item),
            ),
          ),

          SizedBox(height: size.height * 0.02),

          QuoteSummaryCardWidget(
            subtotal: subtotal,
            ivaPercent: ivaPercent,
            ivaAmount: iva,
            total: total,
          ),
        ],
      ),
    );
  }
}
