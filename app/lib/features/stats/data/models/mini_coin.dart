import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'mini_coin.g.dart';

@JsonSerializable(createToJson: false)
class MiniCoin {
  const MiniCoin({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.priceChangePercentage24h,
  });

  final String id;
  final String symbol;
  final String name;
  final String? image;

  @JsonKey(fromJson: toDoubleOrNull)
  final double? currentPrice;
  @JsonKey(fromJson: toDoubleOrNull)
  final double? priceChangePercentage24h;

  factory MiniCoin.fromJson(Map<String, dynamic> json) =>
      _$MiniCoinFromJson(json);
}