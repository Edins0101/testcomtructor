import 'dart:convert';

QuoteDetailData quoteDetailDataFromJson(String str) =>
    QuoteDetailData.fromJson(json.decode(str));

String quoteDetailDataToJson(QuoteDetailData data) =>
    json.encode(data.toJson());

class QuoteDetailData {
  final QuoteSummary quote;
  final List<QuoteItemDetail> items;

  QuoteDetailData({
    required this.quote,
    required this.items,
  });

  factory QuoteDetailData.fromJson(Map<String, dynamic> json) =>
      QuoteDetailData(
        quote: QuoteSummary.fromJson(json['quote']),
        items: (json['items'] as List<dynamic>)
            .map((x) => QuoteItemDetail.fromJson(x))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'quote': quote.toJson(),
        'items': items.map((x) => x.toJson()).toList(),
      };
}

class QuoteSummary {
  final int id;
  final int items;          // cantidad de ítems
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuoteSummary({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuoteSummary.fromJson(Map<String, dynamic> json) => QuoteSummary(
        id: json['id'],
        items: json['items'],
        total: (json['total'] as num).toDouble(),
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items,
        'total': total,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class QuoteItemDetail {
  final int id;
  final int quoteId;
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  QuoteItemDetail({
    required this.id,
    required this.quoteId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory QuoteItemDetail.fromJson(Map<String, dynamic> json) =>
      QuoteItemDetail(
        id: json['id'],
        quoteId: json['quoteId'],
        productId: json['productId'],
        productName: json['productName'],
        quantity: json['quantity'],
        unitPrice: (json['unitPrice'] as num).toDouble(),
        lineTotal: (json['lineTotal'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'quoteId': quoteId,
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'lineTotal': lineTotal,
      };
}
