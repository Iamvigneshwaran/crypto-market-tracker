// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartResponse _$ChartResponseFromJson(Map<String, dynamic> json) =>
    ChartResponse(
      source: json['source'] as String,
      days: (json['days'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
