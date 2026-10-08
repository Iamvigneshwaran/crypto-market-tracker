import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/coin_detail_repository.dart';
import '../../data/models/chart_response.dart';
import '../../data/models/coin_detail_response.dart';

/// Detail header + stats + about. Screen close aanaa auto dispose aagum.
final coinDetailProvider =
    FutureProvider.autoDispose.family<CoinDetailResponse, String>(
  (ref, id) => ref.watch(coinDetailRepositoryProvider).getDetail(id),
  // Riverpod 3 la failed provider auto retry aagum. Error screen udane kaattanum na disable
  retry: (count, error) => null,
);

typedef ChartKey = ({String id, int days});

/// Chart data. Range (days) maathumbodhu idhu mattum reload aagum, header reload aagaadhu.
final coinChartProvider =
    FutureProvider.autoDispose.family<ChartResponse, ChartKey>(
  (ref, key) =>
      ref.watch(coinDetailRepositoryProvider).getChart(key.id, key.days),
  retry: (count, error) => null,
);