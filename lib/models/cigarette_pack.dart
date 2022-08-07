import 'package:flutter/material.dart';
import 'package:in_pack/widgets/cigarette_logo.dart';

enum CigaretteType { slim, regular }

class CigarettePack {
  final String name;
  final CigaretteType type;
  final CigaretteLogo logo;
    
  CigarettePack(this.name, this.type, this.logo);

  static List<CigarettePack> cigarettePacks = [
    CigarettePack('Marlboro Red', CigaretteType.regular, CigaretteLogo(backgroundColor: Colors.red, logoText: const Text('MARLBORO RED',
          style: TextStyle(fontSize: 25, color: Colors.white)),))
  ];

}
