import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/coin_icon.dart';
import '../../../../core/widgets/price_change_chip.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.rows,
  });

  final String title;
  final IconData icon;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  rows[i],
                  if (i < rows.length - 1) const Divider(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCoinRow extends StatelessWidget {
  const StatsCoinRow({
    super.key,
    required this.index,
    required this.id,
    required this.name,
    required this.symbol,
    this.image,
    this.price,
    this.change,
  });

  final int index;
  final String id;
  final String name;
  final String symbol;
  final String? image;
  final double? price;
  final double? change;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push('/coin/$id'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '$index',
                style: tt.bodySmall?.copyWith(color: colors.textSecondary),
              ),
            ),
            CoinIcon(url: image, symbol: symbol, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    symbol.toUpperCase(),
                    style: tt.bodySmall?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Fmt.priceOrDash(price),
                  style: tt.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600)
                      .tabular,
                ),
                const SizedBox(height: 4),
                PriceChangeChip(value: change),
              ],
            ),
          ],
        ),
      ),
    );
  }
}