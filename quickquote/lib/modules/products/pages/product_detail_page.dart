import 'package:flutter/material.dart';
import 'package:quickquote/modules/products/widgets/product_detail.dart';
import 'package:quickquote/shared/widgets/provider_layout.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.globalKey});
  final GlobalKey globalKey;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      keyDismiss: widget.globalKey,
      backPageView: true,
      title: 'Detalles del producto',
      nameInterceptor: 'ProductDetail',
      requiredStack: false,
      child: ProductDetailWidget(),
    );
  }
}
