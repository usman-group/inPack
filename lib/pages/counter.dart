import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:in_pack/utils/navbar_page.dart';

Stream stream() async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield Random().nextInt(1000);
  }
}

class CounterPage extends StatelessWidget implements NavigationBarPage {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        width: 100,
        child: StreamBuilder(
          builder: (context, snapshot) => Text(snapshot.data.toString()),
          stream: stream(),
        ));
  }

  @override
  get icon => const Icon(Icons.add);

  @override
  get label => 'Счётчик';
}
