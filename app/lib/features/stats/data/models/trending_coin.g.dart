// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingCoin _$TrendingCoinFromJson(Map<String, dynamic> json) => TrendingCoin(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  marketCapRank: toIntOrNull(json['marketCapRank']),
  price: toDoubleOrNull(json['price']),
  priceChangePercentage24h: toDoubleOrNull(json['priceChangePercentage24h']),
);
