import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pack/bloc/cigarette_bloc.dart';
import 'package:in_pack/models/cigarette.dart';
import 'package:in_pack/widgets/bottom_navbar.dart';

class CigarettePage extends StatefulWidget implements NavigationBarPage {
  const CigarettePage({super.key});

  @override
  State<CigarettePage> createState() => _CigarettePageState();

  @override
  get icon => const Icon(Icons.smoking_rooms_rounded);

  @override
  get label => 'Пачки';
}

class _CigarettePageState extends State<CigarettePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocBuilder<CigaretteBloc, CigaretteState>(
          builder: (context, state) {
            if (state is CigaretteInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CigaretteLoaded) {
              final random = Random();
              return Column(
                children: [
                  Text(
                    state.cigarettes.length.toString(),
                    style: const TextStyle(fontSize: 20, fontFamily: 'SF'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: state.cigarettes
                          .map((cigarette) => Positioned(
                              left: random.nextInt(250).toDouble(),
                              top: random.nextInt(400).toDouble(),
                              child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: cigarette.image)))
                          .toList(),
                    ),
                  )
                ],
              );
            } else {
              return const Text('Something went wrong');
            }
          },
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              child: const Icon(Icons.smoking_rooms),
              onPressed: () {
                context.read<CigaretteBloc>().add(
                      AddCigarette(Cigarette.cigarettes[0]),
                    );
              }),
          FloatingActionButton(
              child: const Icon(Icons.smoke_free),
              onPressed: () {
                context.read<CigaretteBloc>().add(
                      RemoveCigarette(Cigarette.cigarettes[0]),
                    );
              }),
          FloatingActionButton(
              child: const Icon(Icons.smoking_rooms_rounded),
              onPressed: () {
                context.read<CigaretteBloc>().add(
                      AddCigarette(Cigarette.cigarettes[1]),
                    );
              }),
          FloatingActionButton(
              child: const Icon(Icons.smoke_free_rounded),
              onPressed: () {
                context.read<CigaretteBloc>().add(
                      RemoveCigarette(Cigarette.cigarettes[1]),
                    );
              })
        ]),
      );
}
