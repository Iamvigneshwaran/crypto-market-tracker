import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/coin_detail_providers.dart';
import 'price_chart.dart';

class PriceChartSection extends ConsumerWidget {
  const PriceChartSection({
    super.key,
    required this.coinId,
    required this.days,
  });

  final String coinId;
  final int days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (id: coinId, days: days);
    final async = ref.watch(coinChartProvider(key));
    final colors = context.appColors;

    return async.when(
      loading: () => Shimmer.fromColors(
        baseColor: colors.card,
        highlightColor: colors.border,
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      error: (e, _) => SizedBox(
        height: 220,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, color: colors.textSecondary),
              const SizedBox(height: 8),
              Text(e is ApiException ? e.message : 'Could not load chart.',
                  textAlign: TextAlign.center),
              TextButton.icon(
                onPressed: () => ref.invalidate(coinChartProvider(key)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (res) => Column(
        children: [
          PriceChart(points: res.data, days: days),
          if (res.source == 'fallback' || res.source == 'stale')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 14, color: colors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'Offline sample chart',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}