import 'package:flutter/material.dart';
import 'package:quickquote/modules/products/pages/product_page.dart';

class AppRoutes {
  static const initialRoute = '/Products';
  static Map<String, Widget Function(BuildContext)> routes = {
    '/Products': (_) => const ProductsPage(),
  };
  
  static Null get keyPage => null;

//   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
//     return MaterialPageRoute(
//       builder: (context) => const PageNotFound(),
//     );
//   }
}