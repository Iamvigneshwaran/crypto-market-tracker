import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../market/presentation/widgets/coin_tile.dart';
import '../viewmodel/watchlist_ids_provider.dart';
import '../viewmodel/watchlist_viewmodel.dart';
import '../widgets/watchlist_star_button.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref.watch(watchlistIdsProvider);
    final state = ref.watch(watchlistViewModelProvider);
    final vm = ref.read(watchlistViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: const [ThemeToggleButton()],
      ),
      body: ids.isEmpty
          ? EmptyView(
              icon: Icons.star_border,
              title: 'No coins yet',
              subtitle: 'Tap the star on any coin to add it here.',
              action: FilledButton(
                onPressed: () => context.go('/market'),
                child: const Text('Browse market'),
              ),
            )
          : Column(
              children: [
                OfflineBanner(source: state.source),
                Expanded(child: _body(context, ref, state, vm, ids)),
              ],
            ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    WatchlistState state,
    WatchlistViewModel vm,
    List<String> ids,
  ) {
    switch (state.status) {
      case WatchlistStatus.loading:
        return const ShimmerList(itemCount: 5);
      case WatchlistStatus.error:
        return ErrorView(
          message: state.error ?? 'Something went wrong.',
          onRetry: vm.load,
        );
      case WatchlistStatus.data:
        if (state.coins.isEmpty) {
          return EmptyView(
            icon: Icons.hourglass_empty,
            title: 'Nothing to show',
            subtitle: 'Could not load your saved coins.',
            action: FilledButton(
              onPressed: vm.load,
              child: const Text('Retry'),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => vm.load(silent: true),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.coins.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final coin = state.coins[index];
              return Dismissible(
                key: ValueKey(coin.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: context.appColors.loss,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) {
                  final at = ids.indexOf(coin.id);
                  final idsVm = ref.read(watchlistIdsProvider.notifier);
                  idsVm.remove(coin.id);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${coin.name} removed'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () => idsVm.add(coin.id, index: at),
                        ),
                      ),
                    );
                },
                child: CoinTile(
                  coin: coin,
                  leading: WatchlistStarButton(coinId: coin.id),
                  onTap: () => context.push('/coin/${coin.id}'),
                ),
              );
            },
          ),
        );
    }
  }
}