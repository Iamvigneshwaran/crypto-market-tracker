import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/stats_response.dart';
import '../../data/stats_repository.dart';

class StatsViewModel extends AsyncNotifier<StatsResponse> {
  @override
  Future<StatsResponse> build() {
    // Backend cache 60s, so 60s ku oru dhadava silent refresh
    final timer = Timer.periodic(const Duration(seconds: 60), (_) => refresh());
    ref.onDispose(timer.cancel);
    return ref.read(statsRepositoryProvider).getStats();
  }

  /// Pull-to-refresh / auto refresh. Fail aanaa pazhaya data apdiye irukkum.
  Future<void> refresh() async {
    try {
      final res = await ref.read(statsRepositoryProvider).getStats();
      state = AsyncData(res);
    } catch (e, st) {
      if (!state.hasValue) state = AsyncError(e, st);
    }
  }

  /// Error screen la Retry: skeleton kaattitu thirumba load pannum.
  Future<void> reload() async {
    state = const AsyncLoading();
    try {
      state = AsyncData(await ref.read(statsRepositoryProvider).getStats());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final statsViewModelProvider =
    AsyncNotifierProvider<StatsViewModel, StatsResponse>(
  StatsViewModel.new,
  retry: (count, error) => null,
);