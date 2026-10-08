// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinDetailResponse _$CoinDetailResponseFromJson(Map<String, dynamic> json) =>
    CoinDetailResponse(
      source: json['source'] as String,
      data: CoinDetail.fromJson(json['data'] as Map<String, dynamic>),
    );
