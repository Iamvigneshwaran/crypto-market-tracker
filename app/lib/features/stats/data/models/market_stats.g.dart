// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketStats _$MarketStatsFromJson(Map<String, dynamic> json) => MarketStats(
  totalMarketCap: toDoubleOrNull(json['totalMarketCap']),
  totalVolume: toDoubleOrNull(json['totalVolume']),
  marketCapChangePercentage24h: toDoubleOrNull(
    json['marketCapChangePercentage24h'],
  ),
  btcDominance: toDoubleOrNull(json['btcDominance']),
  ethDominance: toDoubleOrNull(json['ethDominance']),
  activeCryptocurrencies: toIntOrNull(json['activeCryptocurrencies']),
  markets: toIntOrNull(json['markets']),
  trending:
      (json['trending'] as List<dynamic>?)
          ?.map((e) => TrendingCoin.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  topGainers:
      (json['topGainers'] as List<dynamic>?)
          ?.map((e) => MiniCoin.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  topLosers:
      (json['topLosers'] as List<dynamic>?)
          ?.map((e) => MiniCoin.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);
