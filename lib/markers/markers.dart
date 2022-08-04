import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

const double markerSize = 30;
const TextStyle emptyFieldTextStyle = TextStyle(color: Colors.red);

class EquatableMarker extends Marker with EquatableMixin {
  EquatableMarker({
    required super.point,
    required super.builder,
    super.anchorPos,
    required super.height,
    required super.width,
    super.key,
    super.rotate,
    super.rotateAlignment,
    super.rotateOrigin,
  });

  @override
  List<Object?> get props => [point];
}

abstract class MarkerWithPopup extends EquatableMarker {
  MarkerWithPopup(
      {required super.point,
      required super.builder,
      super.anchorPos,
      super.key,
      super.rotate,
      super.rotateAlignment,
      super.rotateOrigin})
      : super(height: markerSize, width: markerSize);

  /// For build popup on [FlutterMap]
  Widget popupBuilder(BuildContext context);

  String get categoryName;
}
