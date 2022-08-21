import 'package:flutter/material.dart';

class CigaretteLogo extends StatelessWidget {
  final Image image;

  // static const CigaretteLogo defaultLogo = CigaretteLogo(
  //     logoText: Text(
  //       'НЕТ СИЖЕК',
  //       style: TextStyle(
  //           color: Colors.black,
  //           fontFamily: 'Roboto',
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold),
  //     ),
  //     backgroundColor: Colors.white);

  const CigaretteLogo({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // boxShadow: const [
        //   BoxShadow(
        //       blurRadius: 10,
        //       spreadRadius: 5,
        //       color: Colors.black12,
        //       offset: Offset(0, 0))
        // ],
      ),
      child: image,
    );
  }
}
