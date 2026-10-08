import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/coin_icon.dart';
import '../../../../core/widgets/price_change_chip.dart';
import '../../data/models/coin_detail.dart';

class CoinHeader extends StatelessWidget {
  const CoinHeader({super.key, required this.detail});
  final CoinDetail detail;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CoinIcon(url: detail.image, symbol: detail.symbol, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          detail.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tt.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (detail.marketCapRank != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#${detail.marketCapRank}',
                            style: tt.labelMedium
                                ?.copyWith(color: colors.textSecondary),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    detail.symbol.toUpperCase(),
                    style: tt.bodyMedium?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          Fmt.priceOrDash(detail.currentPrice),
          style:
              tt.headlineMedium!.copyWith(fontWeight: FontWeight.w700).tabular,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            PriceChangeChip(value: detail.priceChangePercentage24h),
            const SizedBox(width: 8),
            Text('24h',
                style: tt.bodySmall?.copyWith(color: colors.textSecondary)),
          ],
        ),
      ],
    );
  }
}