import 'package:flutter/material.dart';
import 'package:in_pack/widgets/cigarette_logo.dart';

enum CigaretteType { slim, regular }

class CigarettePack {
  final String name;
  final CigaretteType type;
  final Widget logo;

  const CigarettePack(this.name, this.type, this.logo);

  static List<CigarettePack> cigarettePacks = [
    CigarettePack('Marlboro Red', CigaretteType.regular,
        CigaretteLogo(image: Image.asset('assets/images/marlboro_red_logo.png'))),
    CigarettePack('Winston', CigaretteType.regular,
        CigaretteLogo(image: Image.asset('assets/images/winston_logo.png'))),
    CigarettePack('Chapman', CigaretteType.regular,
        CigaretteLogo(image: Image.asset('assets/images/chapman_logo.png'))),

  ];

  String toJson() {
    return cigarettePacks.indexOf(this).toString();
  }

  factory CigarettePack.fromJson(String jsonString) {
    return CigarettePack.cigarettePacks[int.parse(jsonString)];
  }
}
