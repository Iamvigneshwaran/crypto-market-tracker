import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../viewmodel/stats_viewmodel.dart';
import '../widgets/dominance_chart.dart';
import '../widgets/stats_coin_section.dart';
import '../widgets/summary_cards.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(statsViewModelProvider);
    final vm = ref.read(statsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Stats'),
        actions: const [ThemeToggleButton()],
      ),
      body: async.when(
        loading: () => const _StatsSkeleton(),
        error: (e, _) => ErrorView(
          message: e is ApiException ? e.message : 'Something went wrong.',
          onRetry: vm.reload,
        ),
        data: (res) {
          final s = res.data;
          return Column(
            children: [
              OfflineBanner(source: res.source),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: vm.refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    children: [
                      SummaryCards(stats: s),
                      const SizedBox(height: 12),
                      DominanceChart(btc: s.btcDominance, eth: s.ethDominance),
                      StatsSection(
                        title: 'Trending',
                        icon: Icons.local_fire_department_outlined,
                        rows: [
                          for (var i = 0; i < s.trending.length; i++)
                            StatsCoinRow(
                              index: i + 1,
                              id: s.trending[i].id,
                              name: s.trending[i].name,
                              symbol: s.trending[i].symbol,
                              image: s.trending[i].image,
                              price: s.trending[i].price,
                              change: s.trending[i].priceChangePercentage24h,
                            ),
                        ],
                      ),
                      StatsSection(
                        title: 'Top gainers',
                        icon: Icons.trending_up,
                        rows: [
                          for (var i = 0; i < s.topGainers.length; i++)
                            StatsCoinRow(
                              index: i + 1,
                              id: s.topGainers[i].id,
                              name: s.topGainers[i].name,
                              symbol: s.topGainers[i].symbol,
                              image: s.topGainers[i].image,
                              price: s.topGainers[i].currentPrice,
                              change: s.topGainers[i].priceChangePercentage24h,
                            ),
                        ],
                      ),
                      StatsSection(
                        title: 'Top losers',
                        icon: Icons.trending_down,
                        rows: [
                          for (var i = 0; i < s.topLosers.length; i++)
                            StatsCoinRow(
                              index: i + 1,
                              id: s.topLosers[i].id,
                              name: s.topLosers[i].name,
                              symbol: s.topLosers[i].symbol,
                              image: s.topLosers[i].image,
                              price: s.topLosers[i].currentPrice,
                              change: s.topLosers[i].priceChangePercentage24h,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Widget block(double h, {double r = 12}) => Container(
          height: h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r),
          ),
        );

    Widget pair() => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(child: block(84)),
              const SizedBox(width: 12),
              Expanded(child: block(84)),
            ],
          ),
        );

    return Shimmer.fromColors(
      baseColor: colors.card,
      highlightColor: colors.border,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          pair(),
          pair(),
          pair(),
          block(120),
          const SizedBox(height: 24),
          block(20, r: 6),
          const SizedBox(height: 12),
          block(200),
        ],
      ),
    );
  }
}