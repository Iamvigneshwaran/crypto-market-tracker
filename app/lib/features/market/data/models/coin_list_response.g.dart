// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinListResponse _$CoinListResponseFromJson(Map<String, dynamic> json) =>
    CoinListResponse(
      source: json['source'] as String,
      page: (json['page'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Coin.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
