// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistResponse _$WatchlistResponseFromJson(Map<String, dynamic> json) =>
    WatchlistResponse(
      source: json['source'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Coin.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
