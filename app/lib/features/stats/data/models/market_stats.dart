import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'mini_coin.dart';
import 'trending_coin.dart';

part 'market_stats.g.dart';

@JsonSerializable(createToJson: false)
class MarketStats {
  const MarketStats({
    this.totalMarketCap,
    this.totalVolume,
    this.marketCapChangePercentage24h,
    this.btcDominance,
    this.ethDominance,
    this.activeCryptocurrencies,
    this.markets,
    this.trending = const [],
    this.topGainers = const [],
    this.topLosers = const [],
  });

  @JsonKey(fromJson: toDoubleOrNull)
  final double? totalMarketCap;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? totalVolume;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? marketCapChangePercentage24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? btcDominance;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? ethDominance;

  @JsonKey(fromJson: toIntOrNull)
  final int? activeCryptocurrencies;

  /// CoinGecko /global la "markets" = exchanges count
  @JsonKey(fromJson: toIntOrNull)
  final int? markets;

  @JsonKey(defaultValue: <TrendingCoin>[])
  final List<TrendingCoin> trending;
  @JsonKey(defaultValue: <MiniCoin>[])
  final List<MiniCoin> topGainers;
  @JsonKey(defaultValue: <MiniCoin>[])
  final List<MiniCoin> topLosers;

  factory MarketStats.fromJson(Map<String, dynamic> json) =>
      _$MarketStatsFromJson(json);
}