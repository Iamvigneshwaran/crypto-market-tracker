import 'package:json_annotation/json_annotation.dart';

import 'market_stats.dart';

part 'stats_response.g.dart';

@JsonSerializable(createToJson: false)
class StatsResponse {
  const StatsResponse({required this.source, required this.data});

  final String source;
  final MarketStats data;

  factory StatsResponse.fromJson(Map<String, dynamic> json) =>
      _$StatsResponseFromJson(json);
}