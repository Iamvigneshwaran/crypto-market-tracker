import 'package:json_annotation/json_annotation.dart';

import 'coin.dart';

part 'coin_list_response.g.dart';

@JsonSerializable(createToJson: false)
class CoinListResponse {
  const CoinListResponse({
    required this.source,
    required this.page,
    required this.perPage,
    required this.total,
    required this.data,
  });

  final String source;
  final int page;
  final int perPage;
  final int total;
  final List<Coin> data;

  factory CoinListResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinListResponseFromJson(json);
}