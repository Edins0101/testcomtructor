import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/providers/functional_provider.dart';
import 'package:quickquote/shared/widgets/provider_layout.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';
import 'package:quickquote/shared/providers/quote_provider.dart';

class QuoteCartPage extends StatefulWidget {
  const QuoteCartPage({super.key, required this.globalKey});
  final GlobalKey globalKey;
  @override
  State<QuoteCartPage> createState() => _QuoteCartPageState();
}

class _QuoteCartPageState extends State<QuoteCartPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fp = Provider.of<FunctionalProvider>(context);
    final qp = Provider.of<QuoteProvider>(context);
    // final items = qp.items;

    return MainLayout(
      title: 'Mi cotización',
      keyDismiss: widget.globalKey,
      nameInterceptor: 'QuoteCartPage',
      backPageView: true,
      requiredStack: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        child: qp.items.isEmpty
            ? Center(
                child: TextWidget(
                  title: 'Aún no has agregado productos a la cotización.',
                  color: AppTheme.black,
                  fontSize: size.width * 0.04,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.65,
                    child: ListView.separated(
                      itemCount: qp.items.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: size.height * 0.015),
                      itemBuilder: (context, index) {
                        final item = qp.items[index];
                        final p = item.product;

                        return Card(
                          elevation: 4,
                          shadowColor: AppTheme.gray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.04),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bloque izq: nombre y categoría
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitleWidget(
                                        title: p.name,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.045,
                                        color: AppTheme.black,
                                      ),
                                      SizedBox(height: size.height * 0.005),
                                      TextWidget(
                                        title: p.category,
                                        fontSize: size.width * 0.032,
                                        color: AppTheme.gray,
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      TextWidget(
                                        title: 'Cantidad: ${item.quantity}',
                                        fontSize: size.width * 0.035,
                                        color: AppTheme.black,
                                      ),
                                      TextWidget(
                                        title:
                                            'Precio unitario: \$${p.price.toStringAsFixed(2)}',
                                        fontSize: size.width * 0.033,
                                        color: Colors.blueGrey,
                                      ),
                                    ],
                                  ),
                                ),

                                // Bloque der: subtotal + borrar
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextWidget(
                                      title: 'Subtotal',
                                      fontSize: size.width * 0.032,
                                      color: AppTheme.gray,
                                    ),
                                    TextWidget(
                                      title:
                                          '\$${item.subtotal.toStringAsFixed(2)}',
                                      fontSize: size.width * 0.04,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        qp.removeItem(p.id);
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: size.height * 0.015),

                  // Total general
                  Container(
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          title: 'Total cotización',
                          fontSize: size.width * 0.04,
                          color: AppTheme.black,
                          fontWeight: FontWeight.bold,
                        ),
                        TextWidget(
                          title: '\$${qp.total.toStringAsFixed(2)}',
                          fontSize: size.width * 0.045,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Botón enviar
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: ElevatedButton.icon(
                      onPressed: qp.items.isEmpty
                          ? null
                          : () {
                              qp.clearQuote();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cotización enviada'),
                                ),
                              );
                              fp.dismissPage(key: widget.globalKey);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.send_outlined),
                      label: TextWidget(
                        title: 'Enviar cotización',
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
