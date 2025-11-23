// import 'package:flutter/material.dart';

// class ProductsPage extends StatefulWidget {
//   const ProductsPage({Key? key}) : super(key: key);

//   @override
//   State<ProductsPage> createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<ProductsPage> {
  
//   List<Map<String, dynamic>> filtered = [];
//   bool loading = false;
//   String search = '';

//   @override
//   void initState() {
//     super.initState();
//     loadProducts();
//   }

//   Future<void> loadProducts() async {
//     setState(() {
//       loading = true;
//     });
//     await Future.delayed(const Duration(seconds: 2));

   

//     filtered = products;
//     setState(() {
//       loading = false;
//     });
//   }

//   void filter(String value) {
//     search = value;
//     if (value.isEmpty) {
//       filtered = products;
//     } else {
//       filtered = products
//           .where(
//             (p) => p["name"].toString().toLowerCase().contains(
//               value.toLowerCase(),
//             ),
//           )
//           .toList();
//     }
//     setState(() {});
//   }

//   void addToQuote(Map<String, dynamic> product) {
//     // Aquí se "simula" agregar a una cotización pero no se hace nada real.
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Producto agregado a la cotización: ${product["name"]}"),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Productos'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await loadProducts();
//             },
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: filter,
//               decoration: const InputDecoration(
//                 labelText: 'Buscar producto',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//           if (loading)
//             const Expanded(child: Center(child: CircularProgressIndicator()))
//           else if (filtered.isEmpty)
//             const Expanded(child: Center(child: Text('No hay productos')))
//           else
//             Expanded(
//               child: ListView.builder(
//                 itemCount: filtered.length,
//                 itemBuilder: (context, index) {
//                   final product = filtered[index];
//                   return Card(
//                     child: ListTile(
//                       title: Text(product["name"].toString()),
//                       subtitle: Text(
//                         "Precio: \$${product["price"]} - Stock: ${product["stock"]}",
//                       ),
//                       trailing: ElevatedButton(
//                         onPressed: product["stock"] == 0
//                             ? null
//                             : () {
//                                 addToQuote(product);
//                               },
//                         child: const Text('Cotizar'),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quickquote/shared/widgets/provider_layout.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
   String search = '';
   
  

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      title: 'Productos disponibles',
      nameInterceptor: 'Products',
      requiredStack: true,
      showBottomNavBar: true,
      child: Column(
        children: [
          Text('Aquí va el contenido de la página de productos'),
          // SearchWidget(onFilter: _filterProducts ),
        ],
      ),
    );
  }
}
