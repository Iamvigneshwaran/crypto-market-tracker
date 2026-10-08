import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'models/chart_response.dart';
import 'models/coin_detail_response.dart';

class CoinDetailRepository {
  CoinDetailRepository(this._dio);
  final Dio _dio;

  Future<CoinDetailResponse> getDetail(String id) async {
    try {
      final res = await _dio.get('/coins/$id');
      return CoinDetailResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<ChartResponse> getChart(String id, int days) async {
    try {
      final res = await _dio.get(
        '/coins/$id/chart',
        queryParameters: {'days': days},
      );
      return ChartResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

final coinDetailRepositoryProvider = Provider<CoinDetailRepository>(
  (ref) => CoinDetailRepository(ref.watch(dioProvider)),
);