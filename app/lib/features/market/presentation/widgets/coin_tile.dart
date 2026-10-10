import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/coin_icon.dart';
import '../../../../core/widgets/price_change_chip.dart';
import '../../../../core/widgets/sparkline_view.dart';
import '../../data/models/coin.dart';

class CoinTile extends StatelessWidget {
  const CoinTile({super.key, required this.coin, this.leading, this.onTap});

  final Coin coin;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tt = Theme.of(context).textTheme;
    final up = (coin.priceChangePercentage24h ?? 0) >= 0;
    final rank = coin.marketCapRank != null ? '#${coin.marketCapRank} · ' : '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
        child: Row(
          children: [
            leading ?? const SizedBox(width: 8),
            CoinIcon(url: coin.image, symbol: coin.symbol),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$rank${coin.symbol.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodySmall?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            SparklineView(
              data: coin.sparkline7d,
              color: up ? colors.gain : colors.loss,
              width: 64,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 92,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      Fmt.price(coin.currentPrice),
                      style: tt.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600)
                          .tabular,
                    ),
                  ),
                  const SizedBox(height: 4),
                  PriceChangeChip(value: coin.priceChangePercentage24h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}