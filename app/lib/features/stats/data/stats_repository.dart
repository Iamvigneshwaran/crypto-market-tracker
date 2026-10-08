import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'models/stats_response.dart';

class StatsRepository {
  StatsRepository(this._dio);
  final Dio _dio;

  Future<StatsResponse> getStats() async {
    try {
      final res = await _dio.get('/stats');
      return StatsResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => StatsRepository(ref.watch(dioProvider)),
);