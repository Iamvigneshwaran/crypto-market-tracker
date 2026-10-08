import 'package:json_annotation/json_annotation.dart';

import 'coin_detail.dart';

part 'coin_detail_response.g.dart';

@JsonSerializable(createToJson: false)
class CoinDetailResponse {
  const CoinDetailResponse({required this.source, required this.data});

  final String source;
  final CoinDetail data;

  factory CoinDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailResponseFromJson(json);
}