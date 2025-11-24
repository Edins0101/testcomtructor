import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/providers/quote_provider.dart';
import 'package:quickquote/shared/widgets/text.dart';

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuoteProvider>(context);
    final size = MediaQuery.of(context).size;

    return Visibility(
      visible: qp.selectedProduct!.stock > 0,
      replacement: const TextWidget(
        title: 'No  hay unidades disponibles',
        color: AppTheme.red,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.gray),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: widget.onDecrement,
              icon: const Icon(Icons.remove),
            ),
            TextWidget(
              title: '${widget.quantity}',
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
            IconButton(
              onPressed: widget.onIncrement,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
