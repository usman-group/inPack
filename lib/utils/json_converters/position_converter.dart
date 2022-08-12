import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

class PositionConverter implements JsonConverter<Position, String> {
  const PositionConverter();

  @override
  Position fromJson(String json) {
    json = jsonDecode(json);
    return Position.fromMap(json);
  }

  @override
  String toJson(Position position) => json.encode(position.toJson());
}

