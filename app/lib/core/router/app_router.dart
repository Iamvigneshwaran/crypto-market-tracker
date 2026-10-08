import 'package:go_router/go_router.dart';

import '../../features/coin_detail/presentation/view/coin_detail_screen.dart';
import '../../features/market/presentation/view/market_screen.dart';
import '../../features/stats/presentation/view/stats_screen.dart';
import '../../features/watchlist/presentation/view/watchlist_screen.dart';
import '../widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/market',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/market',
            builder: (context, state) => const MarketScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/stats',
            builder: (context, state) => const StatsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/watchlist',
            builder: (context, state) => const WatchlistScreen(),
          ),
        ]),
      ],
    ),
    // Tabs mela full-screen ah open aagum
    GoRoute(
      path: '/coin/:id',
      builder: (context, state) =>
          CoinDetailScreen(coinId: state.pathParameters['id']!),
    ),
  ],
);