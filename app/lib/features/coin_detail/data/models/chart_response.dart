import 'package:json_annotation/json_annotation.dart';

import 'chart_point.dart';

part 'chart_response.g.dart';

@JsonSerializable(createToJson: false)
class ChartResponse {
  const ChartResponse({
    required this.source,
    required this.days,
    required this.data,
  });

  final String source;
  final int days;
  final List<ChartPoint> data;

  factory ChartResponse.fromJson(Map<String, dynamic> json) =>
      _$ChartResponseFromJson(json);
}