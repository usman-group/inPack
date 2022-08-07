import 'package:flutter/cupertino.dart';

class CigaretteLogo extends StatelessWidget {
  final Color backgroundColor;
  final Text logoText;
  const CigaretteLogo( {super.key, required this.logoText, required this.backgroundColor,});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 75,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child: logoText,
    );
  }
}
