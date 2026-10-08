// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiniCoin _$MiniCoinFromJson(Map<String, dynamic> json) => MiniCoin(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  currentPrice: toDoubleOrNull(json['currentPrice']),
  priceChangePercentage24h: toDoubleOrNull(json['priceChangePercentage24h']),
);
