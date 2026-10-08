import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../market/data/models/coin.dart';
import '../../data/watchlist_repository.dart';
import 'watchlist_ids_provider.dart';

enum WatchlistStatus { loading, data, error }

class WatchlistState {
  const WatchlistState({
    this.status = WatchlistStatus.loading,
    this.coins = const [],
    this.source = 'live',
    this.error,
  });

  final WatchlistStatus status;
  final List<Coin> coins;
  final String source;
  final String? error;

  WatchlistState copyWith({
    WatchlistStatus? status,
    List<Coin>? coins,
    String? source,
    String? error,
  }) {
    return WatchlistState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      source: source ?? this.source,
      error: error ?? this.error,
    );
  }
}

class WatchlistViewModel extends Notifier<WatchlistState> {
  Timer? _timer;

  @override
  WatchlistState build() {
    ref.onDispose(() => _timer?.cancel());
    // Backend cache 60s, so 60s ku oru dhadava silent refresh
    _timer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => load(silent: true),
    );
    // Market la star toggle pannumbodhu list sync aagum
    ref.listen<List<String>>(watchlistIdsProvider, _onIdsChanged);
    Future.microtask(load);
    return const WatchlistState();
  }

  Future<void> load({bool silent = false}) async {
    final ids = ref.read(watchlistIdsProvider);
    if (ids.isEmpty) {
      state = const WatchlistState(
        status: WatchlistStatus.data,
        source: 'none',
      );
      return;
    }
    if (!silent) state = state.copyWith(status: WatchlistStatus.loading);

    try {
      final res = await ref.read(watchlistRepositoryProvider).getCoins(ids);
      final byId = {for (final c in res.data) c.id: c};
      // User save panna order la kaattanum
      final ordered = [
        for (final id in ref.read(watchlistIdsProvider))
          if (byId[id] != null) byId[id]!,
      ];
      state = WatchlistState(
        status: WatchlistStatus.data,
        coins: ordered,
        source: res.source,
      );
    } catch (e) {
      if (silent && state.status == WatchlistStatus.data) return;
      state = state.copyWith(
        status: WatchlistStatus.error,
        error: e is ApiException ? e.message : 'Something went wrong.',
      );
    }
  }

  void _onIdsChanged(List<String>? previous, List<String> next) {
    final have = state.coins.map((c) => c.id).toSet();
    final nextSet = next.toSet();
    if (nextSet.every(have.contains)) {
      // Removal mattum: refetch vendaam, local ah filter pannu
      state = state.copyWith(
        coins: state.coins.where((c) => nextSet.contains(c.id)).toList(),
      );
    } else {
      load(silent: state.coins.isNotEmpty);
    }
  }
}

final watchlistViewModelProvider =
    NotifierProvider<WatchlistViewModel, WatchlistState>(
  WatchlistViewModel.new,
);