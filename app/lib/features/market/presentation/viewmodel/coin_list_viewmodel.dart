import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/coin_repository.dart';
import 'coin_list_state.dart';

class CoinListViewModel extends Notifier<CoinListState> {
  static const _perPage = 20;
  Timer? _debounce;
  Timer? _autoRefresh;

  @override
  CoinListState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _autoRefresh?.cancel();
    });
    _autoRefresh = Timer.periodic(const Duration(seconds: 60), (_) {
      if (state.page == 1 && state.status == ListStatus.data) {
        _fetch(page: 1, replace: true, silent: true);
      }
    });
    Future.microtask(load);
    return const CoinListState();
  }

  Future<void> load() async {
    state = state.copyWith(status: ListStatus.loading, clearError: true);
    await _fetch(page: 1, replace: true);
  }

  Future<void> refresh() => _fetch(page: 1, replace: true, silent: true);

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != ListStatus.data) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    await _fetch(page: state.page + 1, replace: false);
  }

  void setQuery(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = q.trim();
      if (trimmed == state.query) return;
      state = state.copyWith(query: trimmed);
      load();
    });
  }

  void setSort(CoinSort sort) {
    state = state.copyWith(sort: sort, ascending: sort == CoinSort.name);
    load();
  }

  void toggleOrder() {
    state = state.copyWith(ascending: !state.ascending);
    load();
  }

  void setFilter(CoinFilter filter) {
    if (filter == state.filter) return;
    state = state.copyWith(filter: filter);
    load();
  }

  bool _sameRequest(CoinListState s) =>
      state.query == s.query &&
      state.sort == s.sort &&
      state.ascending == s.ascending &&
      state.filter == s.filter;

  Future<void> _fetch({
    required int page,
    required bool replace,
    bool silent = false,
  }) async {
    final s = state;
    try {
      final res = await ref.read(coinRepositoryProvider).getCoins(
            q: s.query,
            sort: s.sort.apiValue,
            order: s.ascending ? 'asc' : 'desc',
            filter: s.filter.apiValue,
            page: page,
            perPage: _perPage,
          );
      if (!_sameRequest(s)) return;
      final coins = replace ? res.data : [...state.coins, ...res.data];
      state = state.copyWith(
        coins: coins,
        status: ListStatus.data,
        page: page,
        hasMore: coins.length < res.total,
        source: res.source,
        isLoadingMore: false,
        clearError: true,
      );
    } catch (e) {
      if (!_sameRequest(s)) return;
      if (!replace) {
        state = state.copyWith(isLoadingMore: false);
        return;
      }
      if (silent && state.coins.isNotEmpty) return;
      state = state.copyWith(
        status: ListStatus.error,
        error: e is ApiException ? e.message : 'Something went wrong.',
        isLoadingMore: false,
      );
    }
  }
}

final coinListViewModelProvider =
    NotifierProvider<CoinListViewModel, CoinListState>(CoinListViewModel.new);