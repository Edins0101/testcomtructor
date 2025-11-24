import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/modules/quotes/model/quote_response.dart';
import 'package:quickquote/modules/quotes/pages/quote_detail.dart';
import 'package:quickquote/modules/quotes/services/quote_service.dart';
import 'package:quickquote/modules/quotes/widgets/quote_card.dart';
import 'package:quickquote/modules/quotes/widgets/quote_proyect_card.dart';
import 'package:quickquote/shared/helpers/global_helper.dart';
import 'package:quickquote/shared/providers/functional_provider.dart';
import 'package:quickquote/shared/providers/quote_provider.dart';

class QuotesByPriorityWidget extends StatefulWidget {
  const QuotesByPriorityWidget({super.key});

  @override
  State<QuotesByPriorityWidget> createState() => _QuotesByPriorityWidgetState();
}

class _QuotesByPriorityWidgetState extends State<QuotesByPriorityWidget> {
  final QuoteService _service = QuoteService();
  final quoteDetailPageKey = GlobalHelper.genKey();

  bool _groupByProject = false;
  QuotePriorityResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadQuotes();
      setState(() {});
    });
  }

  void _goDetailQuote(QuotePriority quote) {
    final fp = Provider.of<FunctionalProvider>(context, listen: false);
    final qp = Provider.of<QuoteProvider>(context, listen: false);
    qp.selectQuote(quote);
    fp.addPage(
      key: quoteDetailPageKey,
      content: QuoteDetailPage(
        key: quoteDetailPageKey,
        globalKey: quoteDetailPageKey,
      ),
    );
  }

  Future<void> _loadQuotes() async {
    final resp = await _service.getByPriority(
      context,
      groupByProject: _groupByProject,
    );

    if (!mounted) return;

    if (!resp.error && resp.data != null) {
      setState(() {
        _result = resp.data;
      });
    } else {
      setState(() {
        _error = resp.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_result == null) {
      return const Center(child: Text('Sin datos'));
    }

    return Column(
      children: [
        SwitchListTile(
          title: const Text('Agrupar por proyecto'),
          value: _groupByProject,
          onChanged: (value) {
            setState(() => _groupByProject = value);
            _loadQuotes();
          },
        ),

        SizedBox(
          height: size.height * 0.75,
          child: _buildList(_groupByProject),
        ),
      ],
    );
  }

  Widget _buildList(bool isGrouped) {
    final quotes = _result!.quotes;
    final groups = _result!.groups ?? [];

    return Visibility(
      visible: !isGrouped,
      replacement: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final g = groups[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ProjectQuotesSection(
              group: g,
              onTapQuote: (quote) {
                _goDetailQuote(quote);
              },
            ),
          );
        },
      ),
      child: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          final q = quotes[index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: QuoteCard(
              quote: q,
              onTap: () {
                _goDetailQuote(q);
              },
            ),
          );
        },
      ),
    );
  }
}
