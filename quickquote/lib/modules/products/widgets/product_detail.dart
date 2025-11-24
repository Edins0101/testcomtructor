import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/modules/products/model/product_detail_response.dart';
import 'package:quickquote/modules/products/model/product_response.dart';
import 'package:quickquote/modules/products/services/product_service.dart';
import 'package:quickquote/modules/products/widgets/card_spec.dart';
import 'package:quickquote/modules/products/widgets/product_banner.dart';
import 'package:quickquote/modules/products/widgets/product_price.dart';
import 'package:quickquote/modules/products/widgets/product_quantity.dart';
import 'package:quickquote/shared/providers/quote_provider.dart';
import 'package:quickquote/shared/widgets/text.dart';
import 'package:quickquote/shared/widgets/title.dart';

class ProductDetailWidget extends StatefulWidget {
  const ProductDetailWidget({super.key});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  final ProductService _productService = ProductService();

  ProductDetailData? _detail;
  bool _isLoadingDetail = false;
  String? _errorDetail;

  @override
  void initState() {
    super.initState();
    // Esperar a que el widget tenga contexto para leer el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProductDetail();
    });
  }

  Future<void> _loadProductDetail() async {
    final qp = Provider.of<QuoteProvider>(context, listen: false);
    final ProductResponse? product = qp.selectedProduct;

    if (product == null) return;

    setState(() {
      _isLoadingDetail = true;
      _errorDetail = null;
    });

    final resp = await _productService.getById(context, product.id);

    if (!mounted) return;

    if (!resp.error && resp.data != null) {
      setState(() {
        _detail = resp.data;
        _isLoadingDetail = false;
      });
    } else {
      setState(() {
        _isLoadingDetail = false;
        _errorDetail =
            resp.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qp = Provider.of<QuoteProvider>(context);
    final ProductResponse? product = qp.selectedProduct;

    if (product == null) {
      return Center(
        child: TextWidget(
          title: 'No se ha seleccionado ningún producto.',
          color: AppTheme.black,
          fontSize: size.width * 0.04,
        ),
      );
    }

    final subtotal = qp.currentSubtotal;

    // Descripción: si el detalle ya llegó, uso la del backend
    final String descriptionText =
        _detail?.description ??
        'Producto de la categoría ${product.category}. Ajusta esta descripción según tu modelo.';

    // Specs: por ahora, tomo el primer valor como "dimensión" para tu card
    String dimensionsText = '---';
    if (_detail != null && _detail!.specs.isNotEmpty) {
      // ejemplo: si specs = { "peso": "100lb" } → "peso: 100lb"
      final firstEntry = _detail!.specs.entries.first;
      dimensionsText = '${firstEntry.key}: ${firstEntry.value}';
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductHeaderBanner(icon: Icons.construction),
          SizedBox(height: size.height * 0.02),

          // Nombre
          TitleWidget(
            title: product.name,
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.06,
            color: AppTheme.black,
          ),

          SizedBox(height: size.height * 0.008),

          // Descripción o loading/error del detalle
          if (_isLoadingDetail)
            Row(
              children: [
                SizedBox(
                  width: size.width * 0.04,
                  height: size.width * 0.04,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: size.width * 0.02),
                TextWidget(
                  title: 'Cargando detalle...',
                  color: AppTheme.black,
                  fontSize: size.width * 0.035,
                ),
              ],
            )
          else if (_errorDetail != null)
            TextWidget(
              title: _errorDetail!,
              color: Colors.red,
              fontSize: size.width * 0.035,
            )
          else
            TextWidget(
              title: descriptionText,
              color: AppTheme.black,
              fontSize: size.width * 0.035,
            ),

          SizedBox(height: size.height * 0.025),

          // Card de especificaciones (ahora usando lo que vino del servicio)
          ProductSpecsCard(
            dimensions: dimensionsText,
          ),

          SizedBox(height: size.height * 0.018),

          // Card de precio + stock
          ProductPriceStockCard(
            price: product.price,
            stock: product.stock,
          ),

          SizedBox(height: size.height * 0.018),

          // Sección de cantidad + subtotal
          ProductQuantitySection(
            quantity: qp.quantity,
            subtotal: subtotal,
            onIncrement: qp.incrementQuantity,
            onDecrement: qp.decrementQuantity,
          ),

          SizedBox(height: size.height * 0.025),

          // Botón "Agregar a Cotización"
          SizedBox(
            width: double.infinity,
            height: size.height * 0.065,
            child: ElevatedButton.icon(
              onPressed: qp.selectedProduct!.stock > 0
                  ? () {
                      qp.addCurrentToQuote();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Producto agregado a la cotización'),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: TextWidget(
                title: 'Agregar a Cotización',
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
