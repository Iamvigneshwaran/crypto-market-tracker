import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'trending_coin.g.dart';

@JsonSerializable(createToJson: false)
class TrendingCoin {
  const TrendingCoin({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.marketCapRank,
    this.price,
    this.priceChangePercentage24h,
  });

  final String id;
  final String symbol;
  final String name;
  final String? image;

  @JsonKey(fromJson: toIntOrNull)
  final int? marketCapRank;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? price;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? priceChangePercentage24h;

  factory TrendingCoin.fromJson(Map<String, dynamic> json) =>
      _$TrendingCoinFromJson(json);
}