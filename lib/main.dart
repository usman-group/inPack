import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_pack/pages/home.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
