// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinDetail _$CoinDetailFromJson(Map<String, dynamic> json) => CoinDetail(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  description: json['description'] as String? ?? '',
  homepage: json['homepage'] as String?,
  categories: json['categories'] == null
      ? const []
      : toStringList(json['categories']),
  genesisDate: json['genesisDate'] as String?,
  marketCapRank: toIntOrNull(json['marketCapRank']),
  currentPrice: toDoubleOrNull(json['currentPrice']),
  marketCap: toDoubleOrNull(json['marketCap']),
  totalVolume: toDoubleOrNull(json['totalVolume']),
  high24h: toDoubleOrNull(json['high24h']),
  low24h: toDoubleOrNull(json['low24h']),
  priceChangePercentage24h: toDoubleOrNull(json['priceChangePercentage24h']),
  priceChangePercentage7d: toDoubleOrNull(json['priceChangePercentage7d']),
  priceChangePercentage30d: toDoubleOrNull(json['priceChangePercentage30d']),
  circulatingSupply: toDoubleOrNull(json['circulatingSupply']),
  totalSupply: toDoubleOrNull(json['totalSupply']),
  maxSupply: toDoubleOrNull(json['maxSupply']),
  ath: toDoubleOrNull(json['ath']),
  athDate: json['athDate'] as String?,
  atl: toDoubleOrNull(json['atl']),
  atlDate: json['atlDate'] as String?,
);
