import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quickquote/modules/products/model/product_response.dart';
import 'package:quickquote/modules/products/pages/product_detail_page.dart';
import 'package:quickquote/modules/products/services/product_service.dart';
import 'package:quickquote/shared/helpers/global_helper.dart';
import 'package:quickquote/shared/models/general_response.dart';
import 'package:quickquote/shared/providers/functional_provider.dart';
import 'package:quickquote/shared/providers/quote_provider.dart';

import 'package:quickquote/shared/widgets/card.dart';
import 'package:quickquote/shared/widgets/search_widget.dart';
// o el search que uses para productos

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({super.key, this.globalKey});

  final GlobalKey? globalKey;

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  final ProductService _productService = ProductService();
  final productDetailPageKey = GlobalHelper.genKey();

  List<ProductResponse> _allProducts = [];
  List<ProductResponse> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _tryGetAllProducts();
      setState(() {});
    });
  }

  Future<void> _tryGetAllProducts() async {
    final fp = Provider.of<FunctionalProvider>(context, listen: false);

    final GeneralResponse<List<ProductResponse>> resp = await _productService
        .getAll(context);

    if (!resp.error && resp.data != null) {
      setState(() {
        _allProducts = resp.data!;
        _filteredProducts = List.from(_allProducts);
      });
    } else {
      _showError(fp, title: 'Ups, ocurrió un problema', message: resp.message);
    }
  }

  void _filterProducts(String query) {
    final q = query.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts.where((p) {
        // Puedes ajustar qué campos quieres filtrar
        return p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.id.toString().contains(q) ||
            p.stock.toString().contains(q);
      }).toList();
    });
  }

  void _goDetailProduct(ProductResponse product) {
    final fp = Provider.of<FunctionalProvider>(context, listen: false);
    final qp = Provider.of<QuoteProvider>(context, listen: false);
    qp.selectProduct(product);
    fp.addPage(
      key: productDetailPageKey,
      content: ProductDetailPage(
        key: productDetailPageKey,
        globalKey: productDetailPageKey,
      ),
    );
  }

  void _showError(
    FunctionalProvider fp, {
    required String title,
    required String message,
  }) {
    // final key = GlobalHelper.genKey();
    // fp.showAlert(
    //   key: key,
    //   content: AlertGeneric(
    //     content: WarningAlert(
    //       keyToClose: key,
    //       title: title,
    //       message: message,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔍 Buscador
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            child: SearchWidget(onFilter: _filterProducts),
          ),

          // 📋 Lista de productos
          SizedBox(
            height: size.height * 0.7,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.hardEdge,
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final p = _filteredProducts[index];

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: CardWidget(
                    onTap: () => _goDetailProduct(p),
                    numberRequest: p.name.toString(),
                    // detail: p.category,
                    type: p.category,
                    price: 'Precio: \$${p.price}',
                    stock: 'Stock: ${p.stock}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
