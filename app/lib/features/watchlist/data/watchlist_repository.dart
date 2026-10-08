import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'models/watchlist_response.dart';

class WatchlistRepository {
  WatchlistRepository(this._dio);
  final Dio _dio;

  Future<WatchlistResponse> getCoins(List<String> ids) async {
    try {
      final res = await _dio.get('/watchlist', queryParameters: {
        'ids': ids.join(','),
      });
      return WatchlistResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

final watchlistRepositoryProvider = Provider<WatchlistRepository>(
  (ref) => WatchlistRepository(ref.watch(dioProvider)),
);