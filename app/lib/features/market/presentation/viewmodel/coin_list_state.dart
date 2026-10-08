import '../../data/models/coin.dart';

enum ListStatus { loading, data, error }

enum CoinSort {
  marketCap('market_cap', 'Market cap'),
  price('price', 'Price'),
  volume('volume', 'Volume'),
  change24h('change_24h', '24h %'),
  name('name', 'Name');

  const CoinSort(this.apiValue, this.label);
  final String apiValue;
  final String label;
}

enum CoinFilter {
  all('all', 'All'),
  gainers('gainers', 'Gainers'),
  losers('losers', 'Losers');

  const CoinFilter(this.apiValue, this.label);
  final String apiValue;
  final String label;
}

class CoinListState {
  const CoinListState({
    this.coins = const [],
    this.status = ListStatus.loading,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.query = '',
    this.sort = CoinSort.marketCap,
    this.ascending = false,
    this.filter = CoinFilter.all,
    this.source = 'live',
    this.error,
  });

  final List<Coin> coins;
  final ListStatus status;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String query;
  final CoinSort sort;
  final bool ascending;
  final CoinFilter filter;
  final String source;
  final String? error;

  CoinListState copyWith({
    List<Coin>? coins,
    ListStatus? status,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? query,
    CoinSort? sort,
    bool? ascending,
    CoinFilter? filter,
    String? source,
    String? error,
    bool clearError = false,
  }) {
    return CoinListState(
      coins: coins ?? this.coins,
      status: status ?? this.status,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      ascending: ascending ?? this.ascending,
      filter: filter ?? this.filter,
      source: source ?? this.source,
      error: clearError ? null : (error ?? this.error),
    );
  }
}