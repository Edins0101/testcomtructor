import 'package:flutter/material.dart';
import 'package:quickquote/modules/quotes/model/quote_detail.dart';
import 'package:quickquote/modules/quotes/model/quote_response.dart';
import 'package:quickquote/shared/models/general_response.dart';
import 'package:quickquote/shared/services/http_interceptor.dart';

class QuoteService {
  final InterceptorHttp _interceptorHttp = InterceptorHttp();

  Future<GeneralResponse<QuotePriorityResult>> getByPriority(
    BuildContext context, {
    required bool groupByProject,
    int skip = 0,
    int take = 10,
  }) async {
    const String url = '/quotes/by-priority';

    try {
      final GeneralResponse resp = await _interceptorHttp.request(
        context,
        'GET',
        url,
        null,
        queryParameters: {
          'skip': '$skip',
          'take': '$take',
          'groupByProject': groupByProject.toString(),
        },
        showLoading: true,
      );

      QuotePriorityResult? result;

      if (!resp.error && resp.data != null) {
        final raw = resp.data;

        if (raw is List) {
          final quotes = raw
              .map((e) => QuotePriority.fromJson(e as Map<String, dynamic>))
              .toList();

          result = QuotePriorityResult(
            groupByProject: false,
            quotes: quotes,
            groups: null,
          );
        } else if (raw is Map<String, dynamic>) {
          final bool gb = raw['groupByProject'] ?? groupByProject;

          if (raw['groups'] is List) {
            final groups = (raw['groups'] as List)
                .map(
                  (g) => QuoteProjectGroup.fromJson(g as Map<String, dynamic>),
                )
                .toList();
            final quotes = <QuotePriority>[for (final g in groups) ...g.quotes];

            result = QuotePriorityResult(
              groupByProject: gb,
              quotes: quotes,
              groups: groups,
            );
          } else if (raw['data'] is List) {
            final list = raw['data'] as List;
            final quotes = list
                .map((e) => QuotePriority.fromJson(e as Map<String, dynamic>))
                .toList();

            result = QuotePriorityResult(
              groupByProject: gb,
              quotes: quotes,
              groups: null,
            );
          } else if (raw['data'] is Map &&
              (raw['data'] as Map)['groups'] is List) {
            final data = raw['data'] as Map<String, dynamic>;
            final groups = (data['groups'] as List)
                .map(
                  (g) => QuoteProjectGroup.fromJson(g as Map<String, dynamic>),
                )
                .toList();

            final quotes = <QuotePriority>[for (final g in groups) ...g.quotes];

            result = QuotePriorityResult(
              groupByProject: data['groupByProject'] ?? gb,
              quotes: quotes,
              groups: groups,
            );
          }
        }
      }

      return GeneralResponse<QuotePriorityResult>(
        message: resp.message,
        error: resp.error,
        data: result,
      );
    } catch (e, st) {
      debugPrint('❌ Error getByPriority: $e');
      debugPrint('$st');
      return GeneralResponse<QuotePriorityResult>(
        message: 'Error',
        error: true,
      );
    }
  }

  Future<GeneralResponse<QuoteDetailData>> getQuoteDetail(
    BuildContext context,
    int id,
  ) async {
    final String url = '/quotes/$id';

    try {
      final GeneralResponse resp = await _interceptorHttp.request(
        context,
        'GET',
        url,
        null,
        showLoading: true,
      );

      QuoteDetailData? detail;

      if (!resp.error && resp.data != null) {
        final raw = resp.data;

        // si tu Interceptor ya devuelve solo el "data"
        if (raw is Map<String, dynamic>) {
          if (raw.containsKey('quote') && raw.containsKey('items')) {
            detail = QuoteDetailData.fromJson(raw);
          } else if (raw['data'] is Map<String, dynamic>) {
            // por si todavía viene envuelto en otro "data"
            detail = QuoteDetailData.fromJson(
              raw['data'] as Map<String, dynamic>,
            );
          }
        }
      }

      return GeneralResponse<QuoteDetailData>(
        message: resp.message,
        error: resp.error,
        data: detail,
      );
    } catch (e, st) {
      debugPrint('❌ Error al obtener detalle de cotización: $e');
      debugPrint('📍 $st');

      return GeneralResponse<QuoteDetailData>(message: 'Error', error: true);
    }
  }
}
