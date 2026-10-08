import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'chart_point.g.dart';

@JsonSerializable(createToJson: false)
class ChartPoint {
  const ChartPoint({required this.t, required this.p});

  /// unix milliseconds
  @JsonKey(fromJson: toInt)
  final int t;

  /// price
  @JsonKey(fromJson: toDouble)
  final double p;

  factory ChartPoint.fromJson(Map<String, dynamic> json) =>
      _$ChartPointFromJson(json);
}