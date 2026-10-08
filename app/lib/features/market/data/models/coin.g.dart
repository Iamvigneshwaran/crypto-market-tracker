// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coin _$CoinFromJson(Map<String, dynamic> json) => Coin(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  currentPrice: toDouble(json['currentPrice']),
  marketCap: toDouble(json['marketCap']),
  marketCapRank: toIntOrNull(json['marketCapRank']),
  totalVolume: toDouble(json['totalVolume']),
  high24h: toDoubleOrNull(json['high24h']),
  low24h: toDoubleOrNull(json['low24h']),
  priceChange24h: toDoubleOrNull(json['priceChange24h']),
  priceChangePercentage24h: toDoubleOrNull(json['priceChangePercentage24h']),
  circulatingSupply: toDoubleOrNull(json['circulatingSupply']),
  totalSupply: toDoubleOrNull(json['totalSupply']),
  maxSupply: toDoubleOrNull(json['maxSupply']),
  ath: toDoubleOrNull(json['ath']),
  athChangePercentage: toDoubleOrNull(json['athChangePercentage']),
  sparkline7d: json['sparkline7d'] == null
      ? const []
      : toDoubleList(json['sparkline7d']),
);
