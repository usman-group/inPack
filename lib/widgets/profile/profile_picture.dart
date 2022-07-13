import 'package:flutter/material.dart';


class ProfilePicture extends StatelessWidget {
  ProfilePicture({required this.profileNetworkImage, Key? key}) : super(key: key){
    _imageNotifier = ValueNotifier<NetworkImage>(profileNetworkImage);
  }
  final NetworkImage profileNetworkImage;
  late final ValueNotifier<NetworkImage> _imageNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _imageNotifier,
        builder: (context, NetworkImage value, child) {
          return CircleAvatar(
            backgroundImage: value,
            radius: 40,
          );
        });
  }
}


