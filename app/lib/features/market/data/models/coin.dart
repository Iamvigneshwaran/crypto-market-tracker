import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'coin.g.dart';

@JsonSerializable(createToJson: false)
class Coin {
  const Coin({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    required this.currentPrice,
    required this.marketCap,
    this.marketCapRank,
    required this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.sparkline7d = const [],
  });

  final String id;
  final String symbol;
  final String name;
  final String? image;

  @JsonKey(fromJson: toDouble)
  final double currentPrice;
  @JsonKey(fromJson: toDouble)
  final double marketCap;
  @JsonKey(fromJson: toIntOrNull)
  final int? marketCapRank;
  @JsonKey(fromJson: toDouble)
  final double totalVolume;

  @JsonKey(fromJson: toDoubleOrNull)
  final double? high24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? low24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? priceChange24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? priceChangePercentage24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? circulatingSupply;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? totalSupply;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? maxSupply;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? ath;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? athChangePercentage;

  @JsonKey(fromJson: toDoubleList)
  final List<double> sparkline7d;

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
}