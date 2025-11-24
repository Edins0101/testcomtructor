import 'package:flutter/material.dart';
import 'package:quickquote/modules/products/model/product_detail_response.dart';
import 'package:quickquote/modules/products/model/product_response.dart';
import 'package:quickquote/shared/models/general_response.dart';
import 'package:quickquote/shared/services/http_interceptor.dart';

class ProductService {
  final InterceptorHttp _interceptorHttp = InterceptorHttp();

  Future<GeneralResponse<List<ProductResponse>>> getAll(
    BuildContext context, {
    int skip = 0,
    int take = 10,
  }) async {
    const String url = '/products';

    try {
      final GeneralResponse resp = await _interceptorHttp.request(
        context,
        'GET',
        url,
        null,
        queryParameters: {'skip': skip.toString(), 'take': take.toString()},
        showLoading: true,
      );

      List<ProductResponse>? products;

      if (!resp.error) {
        final dynamic raw = resp.data;

        if (raw is List) {
          products = raw
              .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (raw is Map && raw['data'] is List) {
          products = (raw['data'] as List)
              .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      return GeneralResponse<List<ProductResponse>>(
        message: resp.message,
        error: resp.error,
        data: products,
      );
    } catch (e, stacktrace) {
      debugPrint('❌ Error al obtener productos: $e');
      debugPrint('📍 Stacktrace: $stacktrace');

      return GeneralResponse<List<ProductResponse>>(
        message: 'Error',
        error: true,
      );
    }
  }

  // 👇 NUEVO: obtener detalle por id
  Future<GeneralResponse<ProductDetailData>> getById(
    BuildContext context,
    int id,
  ) async {
    final String url = '/products/$id';

    try {
      final GeneralResponse resp = await _interceptorHttp.request(
        context,
        'GET',
        url,
        null,
        showLoading: true,
      );

      ProductDetailData? productDetail;

      if (!resp.error && resp.data != null) {
        final dynamic raw = resp.data;

        // Si tu Interceptor ya devuelve el "data" del backend:
        // raw debería ser el objeto:
        // { "id": 2, "description": "...", "specs": { ... } }
        if (raw is Map<String, dynamic>) {
          // caso 1: ya viene directo
          if (raw.containsKey('id')) {
            productDetail = ProductDetailData.fromJson(raw);
          }
          // caso 2: todavía viene envuelto en "data"
          else if (raw['data'] is Map<String, dynamic>) {
            productDetail = ProductDetailData.fromJson(
              raw['data'] as Map<String, dynamic>,
            );
          }
        }
      }

      return GeneralResponse<ProductDetailData>(
        message: resp.message,
        error: resp.error,
        data: productDetail,
      );
    } catch (e, stacktrace) {
      debugPrint('❌ Error al obtener detalle del producto: $e');
      debugPrint('📍 Stacktrace: $stacktrace');

      return GeneralResponse<ProductDetailData>(message: 'Error', error: true);
    }
  }
}
