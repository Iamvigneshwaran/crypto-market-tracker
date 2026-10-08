import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../viewmodel/coin_list_state.dart';
import '../viewmodel/coin_list_viewmodel.dart';
import '../widgets/coin_tile.dart';

import '../../../watchlist/presentation/widgets/watchlist_star_button.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
        ref.read(coinListViewModelProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coinListViewModelProvider);
    final vm = ref.read(coinListViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: const [ThemeToggleButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _search,
              builder: (context, value, _) => TextField(
                controller: _search,
                onChanged: vm.setQuery,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search coins',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: value.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _search.clear();
                            vm.setQuery('');
                          },
                        ),
                ),
              ),
            ),
          ),
          _FilterSortBar(state: state, vm: vm),
          OfflineBanner(source: state.source),
          Expanded(child: _buildBody(state, vm)),
        ],
      ),
    );
  }

  Widget _buildBody(CoinListState state, CoinListViewModel vm) {
    switch (state.status) {
      case ListStatus.loading:
        return const ShimmerList();
      case ListStatus.error:
        return ErrorView(
          message: state.error ?? 'Something went wrong.',
          onRetry: vm.load,
        );
      case ListStatus.data:
        if (state.coins.isEmpty) {
          return const EmptyView(
            icon: Icons.search_off,
            title: 'No coins found',
            subtitle: 'Try a different search or filter.',
          );
        }
        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView.separated(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.coins.length + (state.isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              if (index >= state.coins.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              final coin = state.coins[index];
              return CoinTile(
                coin: coin,
                leading: WatchlistStarButton(coinId: coin.id),
                onTap: () => context.push('/coin/${coin.id}'),
              );
            },
          ),
        );
    }
  }
}

class _FilterSortBar extends StatelessWidget {
  const _FilterSortBar({required this.state, required this.vm});
  final CoinListState state;
  final CoinListViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final f in CoinFilter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(f.label),
                        selected: state.filter == f,
                        onSelected: (_) => vm.setFilter(f),
                      ),
                    ),
                ],
              ),
            ),
          ),
          PopupMenuButton<CoinSort>(
            initialValue: state.sort,
            onSelected: vm.setSort,
            itemBuilder: (context) => [
              for (final s in CoinSort.values)
                PopupMenuItem(value: s, child: Text(s.label)),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sort, size: 20),
                  const SizedBox(width: 4),
                  Text(state.sort.label),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: state.ascending ? 'Ascending' : 'Descending',
            icon: Icon(state.ascending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: vm.toggleOrder,
          ),
        ],
      ),
    );
  }
}