import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/price_change_chip.dart';
import '../../data/models/market_stats.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key, required this.stats});
  final MarketStats stats;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      _SummaryCard(
        label: 'Market cap',
        value: Fmt.compactOrDash(stats.totalMarketCap),
        extra: PriceChangeChip(value: stats.marketCapChangePercentage24h),
      ),
      _SummaryCard(
        label: '24h volume',
        value: Fmt.compactOrDash(stats.totalVolume),
      ),
      _SummaryCard(
        label: 'BTC dominance',
        value: Fmt.plainPercent(stats.btcDominance),
      ),
      _SummaryCard(
        label: 'ETH dominance',
        value: Fmt.plainPercent(stats.ethDominance),
      ),
      _SummaryCard(
        label: 'Active coins',
        value: Fmt.count(stats.activeCryptocurrencies),
      ),
      _SummaryCard(
        label: 'Exchanges',
        value: Fmt.count(stats.markets),
      ),
    ];

    // 2 columns, row la rendu card um same height
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: tiles[i]),
              const SizedBox(width: 12),
              Expanded(child: tiles[i + 1]),
            ],
          ),
        ),
      );
      if (i + 2 < tiles.length) rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value, this.extra});

  final String label;
  final String value;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: tt.bodySmall?.copyWith(color: colors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tt.titleMedium!.copyWith(fontWeight: FontWeight.w700).tabular,
          ),
          if (extra != null) ...[const SizedBox(height: 6), extra!],
        ],
      ),
    );
  }
}