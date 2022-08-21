import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pack/bloc/authorisation_bloc.dart';
import 'package:in_pack/bloc/cigarette_bloc.dart';
import 'package:in_pack/pages/authorisation.dart';
import 'package:in_pack/pages/cigarette.dart';
import 'package:in_pack/pages/map.dart';
import 'package:in_pack/pages/profile.dart';
import 'package:in_pack/pages/rooms.dart';
import 'package:in_pack/repositories/user_repository.dart';

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
    systemNavigationBarColor: Colors.brown,

  ));

  User? currentUser = FirebaseAuth.instance.currentUser;

  return runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(create: (_) => UserRepository())
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<MapBloc>(create: (_) => MapBloc()),
              BlocProvider<CigaretteBloc>(
                  create: (_) =>
                  CigaretteBloc()
                    ..add(LoadCigarette())),
              BlocProvider<AuthorisationBloc>(
                  create: (_) => AuthorisationBloc(context.read<UserRepository>()))
            ],
            child: MaterialApp(
              theme: ThemeData(primarySwatch: Colors.brown),
              initialRoute: currentUser == null ? '/authorisation' : '/home',
              routes: {
                '/home': (_) => const HomePage(),
                '/authorisation': (_) => const AuthorisationPage(),
              },
              debugShowCheckedModeBanner: false,
            ),
          );
        }
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const initialPageIndex = 1;
  static const Color _bottomNavigationColor = Colors.brown;
  int _currentIndex = initialPageIndex;
  final _pageController = PageController(initialPage: initialPageIndex);

  final _pages = [
    const RoomsPage(),
    // const AuthorisationPage(),
    const ProfilePage(),
    const MapPage(),
    const CigarettePage(),
  ];

  _onPageChanged(int index) {}

  _onTap(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Чат',
              backgroundColor: _bottomNavigationColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
              backgroundColor: _bottomNavigationColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.room),
              label: 'Карта',
              backgroundColor: _bottomNavigationColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.smoking_rooms),
              label: 'Мини-игра',
              backgroundColor: _bottomNavigationColor),
        ],
        onTap: _onTap,
        backgroundColor: Colors.brown,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(opacity: 1),
        unselectedIconTheme: const IconThemeData(
          opacity: 0.7,
        ),
        currentIndex: _currentIndex,
      ),
    );
  }
}
