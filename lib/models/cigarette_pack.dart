import 'package:flutter/material.dart';
import 'package:in_pack/widgets/cigarette_logo.dart';

enum CigaretteType { slim, regular }

class CigarettePack {
  final String name;
  final CigaretteType type;
  final CigaretteLogo logo;

  const CigarettePack(this.name, this.type, this.logo);

  static List<CigarettePack> cigarettePacks = const [
    CigarettePack(
        'Marlboro Red',
        CigaretteType.regular,
        CigaretteLogo(
          backgroundColor: Colors.red,
          logoText: Text('MARLBORO RED',
              style: TextStyle(fontSize: 25, color: Colors.white)),
        )),
    CigarettePack(
        'Winston Blue Super Slim',
        CigaretteType.slim,
        CigaretteLogo(
          backgroundColor: Colors.blue,
          logoText: Text('WINSTON BLUE SUPER SLIM',
              style: TextStyle(fontSize: 25, color: Colors.white)),
        )),
  ];

  String toJson() {
    return cigarettePacks.indexOf(this).toString();
  }

  factory CigarettePack.fromJson(String jsonString) {
    return CigarettePack.cigarettePacks[int.parse(jsonString)];
  }
}
