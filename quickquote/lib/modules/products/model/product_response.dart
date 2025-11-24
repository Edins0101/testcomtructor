import 'dart:convert';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

// 👇 NUEVO: para lista de productos
List<ProductResponse> productResponseListFromJson(String str) =>
    List<ProductResponse>.from(
      json.decode(str).map((x) => ProductResponse.fromJson(x)),
    );

class ProductResponse {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String category;

  ProductResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
  });

  factory ProductResponse.fromRawJson(String str) =>
      ProductResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        id: json["id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        stock: json["stock"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        "category": category,
      };
}
