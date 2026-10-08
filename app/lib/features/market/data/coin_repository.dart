import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'models/coin_list_response.dart';

class CoinRepository {
  CoinRepository(this._dio);
  final Dio _dio;

  Future<CoinListResponse> getCoins({
    String q = '',
    String sort = 'market_cap',
    String order = 'desc',
    String filter = 'all',
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final res = await _dio.get('/coins', queryParameters: {
        if (q.isNotEmpty) 'q': q,
        'sort': sort,
        'order': order,
        'filter': filter,
        'page': page,
        'perPage': perPage,
      });
      return CoinListResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

final coinRepositoryProvider =
    Provider<CoinRepository>((ref) => CoinRepository(ref.watch(dioProvider)));