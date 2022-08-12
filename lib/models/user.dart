import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_pack/models/cigarette_pack.dart';
import 'package:in_pack/utils/json_converters/position_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum Rank { junior, middle, senior }

@JsonSerializable()
@PositionConverter()
class User extends Equatable {
  const User(
      {required this.id,
      required this.lastSeen,
      required this.name,
      required this.rank,
      this.imageUrl,
      this.lastPosition,
      this.currentPack});

  /// Id for define user
  final String id;

  /// Last seen in app
  final DateTime lastSeen;

  /// Name that will show in user card and user profile
  final String name;

  /// URL of image that will be used as user avatar
  final String? imageUrl;

  /// Last position of user
  final Position? lastPosition;

  /// Rank that will be used for authorisation
  final Rank rank;

  /// Current pack that user has now
  final CigarettePack? currentPack;

  /// To be able to compare users
  @override
  List<Object?> get props => [id];

  /// Creates user from json e.g. from Firestore
  factory User.fromJson(Map<String, dynamic> jsonMap) {
    return _$UserFromJson(jsonMap);
  }

  /// Creates user from raw json string
  factory User.fromRawJson(jsonString) {
    final jsonMap = json.decode(jsonString);
    return User.fromJson(jsonMap);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }

  String toRawJson() {
    return json.encode(toJson());
  }

  /// To create new user from this user
  User copyWith(
      {DateTime? lastSeen,
      String? name,
      Rank? rank,
      CigarettePack? currentPack,
      Position? lastPosition,
      String? imageUrl}) {
    return User(
        id: id,
        lastSeen: lastSeen ?? this.lastSeen,
        name: name ?? this.name,
        rank: rank ?? this.rank,
        currentPack: currentPack ?? this.currentPack,
        lastPosition: lastPosition ?? this.lastPosition,
        imageUrl: imageUrl ?? this.imageUrl);
  }
}
