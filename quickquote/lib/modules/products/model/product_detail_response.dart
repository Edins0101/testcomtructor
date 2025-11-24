import 'dart:convert';

ProductDetailData productDetailDataFromJson(String str) =>
    ProductDetailData.fromJson(json.decode(str));

String productDetailDataToJson(ProductDetailData data) =>
    json.encode(data.toJson());

class ProductDetailData {
  final int id;
  final String description;
  final Map<String, dynamic> specs;

  ProductDetailData({
    required this.id,
    required this.description,
    required this.specs,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) =>
      ProductDetailData(
        id: json["id"],
        description: json["description"],
        specs: json["specs"] != null
            ? Map<String, dynamic>.from(json["specs"])
            : {},
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "specs": specs,
      };
}
