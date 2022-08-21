// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      name: json['name'] as String?,
      rank: $enumDecode(_$RankEnumMap, json['rank']),
      imageUrl: json['imageUrl'] as String?,
      lastPosition: _$JsonConverterFromJson<String, Position>(
          json['lastPosition'], const PositionConverter().fromJson),
      currentPack: json['currentPack'] == null
          ? null
          : CigarettePack.fromJson(json['currentPack'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'lastSeen': instance.lastSeen.toIso8601String(),
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'lastPosition': _$JsonConverterToJson<String, Position>(
          instance.lastPosition, const PositionConverter().toJson),
      'rank': _$RankEnumMap[instance.rank]!,
      'currentPack': instance.currentPack,
    };

const _$RankEnumMap = {
  Rank.junior: 'junior',
  Rank.middle: 'middle',
  Rank.senior: 'senior',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
