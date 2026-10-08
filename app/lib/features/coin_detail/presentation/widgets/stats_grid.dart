import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/coin_detail.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key, required this.detail});
  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final d = detail;

    Color? changeColor(double? v) =>
        v == null ? null : (v >= 0 ? colors.gain : colors.loss);

    String? athSub() {
      final parts = [
        if (d.athChangePercentage != null)
          Fmt.signedPercent(d.athChangePercentage),
        if (d.athDate != null) Fmt.date(d.athDate),
      ];
      return parts.isEmpty ? null : parts.join(' · ');
    }

    final tiles = <Widget>[
      _StatTile(label: 'Market cap', value: Fmt.compactOrDash(d.marketCap)),
      _StatTile(label: '24h volume', value: Fmt.compactOrDash(d.totalVolume)),
      _StatTile(label: '24h high', value: Fmt.priceOrDash(d.high24h)),
      _StatTile(label: '24h low', value: Fmt.priceOrDash(d.low24h)),
      _StatTile(
        label: 'Circulating supply',
        value: Fmt.supply(d.circulatingSupply, symbol: d.symbol),
      ),
      _StatTile(
        label: 'Total supply',
        value: Fmt.supply(d.totalSupply, symbol: d.symbol),
      ),
      _StatTile(
        label: 'Max supply',
        value: d.maxSupply == null
            ? '∞'
            : Fmt.supply(d.maxSupply, symbol: d.symbol),
      ),
      _StatTile(
        label: '7d change',
        value: Fmt.signedPercent(d.priceChangePercentage7d),
        valueColor: changeColor(d.priceChangePercentage7d),
      ),
      _StatTile(
        label: '30d change',
        value: Fmt.signedPercent(d.priceChangePercentage30d),
        valueColor: changeColor(d.priceChangePercentage30d),
      ),
      _StatTile(
        label: 'All-time high',
        value: Fmt.priceOrDash(d.ath),
        subtitle: athSub(),
      ),
      _StatTile(
        label: 'All-time low',
        value: Fmt.priceOrDash(d.atl),
        subtitle: d.atlDate == null ? null : Fmt.date(d.atlDate),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final w = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final t in tiles) SizedBox(width: w, child: t)],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
  });

  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;

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
            style: tt.bodyLarge!
                .copyWith(fontWeight: FontWeight.w600, color: valueColor)
                .tabular,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.bodySmall?.copyWith(color: colors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}