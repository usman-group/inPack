import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Cigarette extends Equatable {
  final String id;
  final String name;
  final Image image;

  const Cigarette({required this.id, required this.name, required this.image});

  @override
  List<Object?> get props => [id, name, image];

  static List<Cigarette> cigarettes = [
    Cigarette(
        id: '0',
        name: 'Marlboro Red',
        image: Image.asset('assets/images/marlboro_red.png')),
    Cigarette(
        id: '1',
        name: 'Winston Blue Super Slims',
        image: Image.asset('assets/images/winston_blue_super_slims.png')),
    Cigarette(
        id: '2',
        name: 'Minion',
        image: Image.asset('assets/images/minion.jpg')),
  ];
}
