import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'coin_detail.g.dart';

@JsonSerializable(createToJson: false)
class CoinDetail {
  const CoinDetail({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.description = '',
    this.homepage,
    this.categories = const [],
    this.genesisDate,
    this.marketCapRank,
    this.currentPrice,
    this.marketCap,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChangePercentage24h,
    this.priceChangePercentage7d,
    this.priceChangePercentage30d,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athDate,
    this.atl,
    this.atlDate,
  });

  final String id;
  final String symbol;
  final String name;
  final String? image;

  @JsonKey(defaultValue: '')
  final String description;
  final String? homepage;

  @JsonKey(fromJson: toStringList)
  final List<String> categories;
  final String? genesisDate;

  @JsonKey(fromJson: toIntOrNull)
  final int? marketCapRank;

  @JsonKey(fromJson: toDoubleOrNull)
  final double? currentPrice;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? marketCap;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? totalVolume;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? high24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? low24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? priceChangePercentage24h;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? priceChangePercentage7d;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? priceChangePercentage30d;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? circulatingSupply;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? totalSupply;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? maxSupply;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? ath;
  final String? athDate;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? atl;
  final String? atlDate;

  /// ATH la irundhu ippo evlo % kammi
  double? get athChangePercentage {
    final a = ath, p = currentPrice;
    if (a == null || p == null || a <= 0) return null;
    return (p / a - 1) * 100;
  }

  factory CoinDetail.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailFromJson(json);
}