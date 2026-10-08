import 'package:json_annotation/json_annotation.dart';

import '../../../market/data/models/coin.dart';

part 'watchlist_response.g.dart';

@JsonSerializable(createToJson: false)
class WatchlistResponse {
  const WatchlistResponse({required this.source, required this.data});

  final String source; // live | cache | stale | fallback | none
  final List<Coin> data;

  factory WatchlistResponse.fromJson(Map<String, dynamic> json) =>
      _$WatchlistResponseFromJson(json);
}