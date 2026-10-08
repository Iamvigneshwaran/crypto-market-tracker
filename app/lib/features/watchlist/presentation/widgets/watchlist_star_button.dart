import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../viewmodel/watchlist_ids_provider.dart';

class WatchlistStarButton extends ConsumerWidget {
  const WatchlistStarButton({super.key, required this.coinId, this.size = 22});

  final String coinId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(
      watchlistIdsProvider.select((ids) => ids.contains(coinId)),
    );
    return IconButton(
      tooltip: saved ? 'Remove from watchlist' : 'Add to watchlist',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      icon: Icon(
        saved ? Icons.star : Icons.star_border,
        size: size,
        color: saved ? Colors.amber : context.appColors.textSecondary,
      ),
      onPressed: () => ref.read(watchlistIdsProvider.notifier).toggle(coinId),
    );
  }
}