import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../watchlist/presentation/widgets/watchlist_star_button.dart';
import '../viewmodel/coin_detail_providers.dart';
import '../widgets/about_section.dart';
import '../widgets/coin_header.dart';
import '../widgets/price_chart_section.dart';
import '../widgets/stats_grid.dart';

class CoinDetailScreen extends ConsumerStatefulWidget {
  const CoinDetailScreen({super.key, required this.coinId});
  final String coinId;

  @override
  ConsumerState<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends ConsumerState<CoinDetailScreen> {
  // Selected range: pure UI state, so local ah vachirukken
  int _days = 7;

  static const _ranges = [
    (1, '1D'),
    (7, '1W'),
    (30, '1M'),
    (90, '3M'),
    (365, '1Y'),
  ];

  Future<void> _refresh() async {
    ref.invalidate(coinDetailProvider(widget.coinId));
    ref.invalidate(coinChartProvider((id: widget.coinId, days: _days)));
    try {
      await ref.read(coinDetailProvider(widget.coinId).future);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(coinDetailProvider(widget.coinId));
    final title = async.hasValue ? async.requireValue.data.name : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          WatchlistStarButton(coinId: widget.coinId, size: 26),
          const ThemeToggleButton(),
        ],
      ),
      body: async.when(
        skipLoadingOnReload: true,
        loading: () => const _DetailSkeleton(),
        error: (e, _) {
          if (e is ApiException && e.statusCode == 404) {
            return EmptyView(
              icon: Icons.search_off,
              title: 'Coin not found',
              action: FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Go back'),
              ),
            );
          }
          return ErrorView(
            message: e is ApiException ? e.message : 'Something went wrong.',
            onRetry: () => ref.invalidate(coinDetailProvider(widget.coinId)),
          );
        },
        data: (res) {
          final d = res.data;
          return Column(
            children: [
              OfflineBanner(source: res.source),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    children: [
                      CoinHeader(detail: d),
                      const SizedBox(height: 20),
                      Center(
                        child: SegmentedButton<int>(
                          showSelectedIcon: false,
                          style: const ButtonStyle(
                            visualDensity: VisualDensity.compact,
                          ),
                          segments: [
                            for (final r in _ranges)
                              ButtonSegment(value: r.$1, label: Text(r.$2)),
                          ],
                          selected: {_days},
                          onSelectionChanged: (s) =>
                              setState(() => _days = s.first),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PriceChartSection(coinId: widget.coinId, days: _days),
                      const SizedBox(height: 24),
                      Text(
                        'Market stats',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      StatsGrid(detail: d),
                      const SizedBox(height: 24),
                      AboutSection(detail: d),
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

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Widget block(double h, {double? w, double r = 8, bool circle = false}) =>
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: circle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: circle ? null : BorderRadius.circular(r),
          ),
        );

    return Shimmer.fromColors(
      baseColor: colors.card,
      highlightColor: colors.border,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              block(48, w: 48, circle: true),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [block(16, w: 140), const SizedBox(height: 8), block(12, w: 60)],
              ),
            ],
          ),
          const SizedBox(height: 20),
          block(32, w: 200),
          const SizedBox(height: 8),
          block(18, w: 90),
          const SizedBox(height: 24),
          block(36, r: 18),
          const SizedBox(height: 16),
          block(220, r: 12),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: block(64, r: 12)),
              const SizedBox(width: 12),
              Expanded(child: block(64, r: 12)),
            ],
          ),
        ],
      ),
    );
  }
}