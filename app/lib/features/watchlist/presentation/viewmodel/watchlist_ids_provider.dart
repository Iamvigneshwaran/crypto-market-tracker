import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/prefs_provider.dart';

class WatchlistIdsNotifier extends Notifier<List<String>> {
  static const _key = 'watchlist_ids';

  @override
  List<String> build() =>
      ref.read(sharedPrefsProvider).getStringList(_key) ?? const [];

  bool contains(String id) => state.contains(id);

  void toggle(String id) => contains(id) ? remove(id) : add(id);

  void add(String id, {int? index}) {
    if (state.contains(id)) return;
    final next = [...state];
    final at = (index == null || index < 0 || index > next.length)
        ? next.length
        : index;
    next.insert(at, id);
    _set(next);
  }

  void remove(String id) => _set(state.where((e) => e != id).toList());

  void _set(List<String> next) {
    state = next;
    ref.read(sharedPrefsProvider).setStringList(_key, next);
  }
}

final watchlistIdsProvider =
    NotifierProvider<WatchlistIdsNotifier, List<String>>(
  WatchlistIdsNotifier.new,
);