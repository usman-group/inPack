import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pack/bloc/cigarette_bloc.dart';
import 'package:in_pack/pages/registration.dart';
import 'package:in_pack/widgets/bottom_navbar.dart';

import 'bloc/map_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Transparent system bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black,
  ));
  return runApp(const MaterialApp(
    home: App(),
    debugShowCheckedModeBanner: false,
  ));
}


class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {});
    });
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(create: (context) => MapBloc()..add(RequestLocation())),
        BlocProvider<CigaretteBloc>(create: (context) => CigaretteBloc()..add(LoadCigarette())),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF6E4B3F),
        appBar: AppBar(
          title: const Icon(Icons.smoking_rooms),
          centerTitle: true,
          backgroundColor: Colors.black38,
        ),
        body: FirebaseAuth.instance.currentUser == null
            ? const RegisterPage()
            : BottomNavbar.bodyWidgets[_pageIndex] as Widget,
        bottomNavigationBar: FirebaseAuth.instance.currentUser == null
            ? null
            : BottomNavbar(
          onTap: (idx) => setState(() {
            _pageIndex = idx;
          }),
          currentIndex: _pageIndex,
        ),
      ),
    );
  }
}
