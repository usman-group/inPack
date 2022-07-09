import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:in_pack/colors.dart' as colors;
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import pages
import './pages/registration_page.dart';
import './pages/user_page.dart';
import './pages/chat_page.dart';
import './pages/list_page.dart';

void main() => runApp(const MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> bodyWidgets = [
    const ChatPanel(),
    const UserPanel(),
    const ListPanel(),
    const RegisterPanel(),
  ];
  int _pageIndex = 0;

  void _initFirebase() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) {
      if (kDebugMode) print('Firebase initialised $value');
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ));
    _initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6E4B3F),
      appBar: AppBar(
        title: const Icon(Icons.smoking_rooms),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      body: bodyWidgets[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_outlined,
                color: Colors.brown,
              ),
              label: 'Chat',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.brown,
            ),
            label: 'User',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: Colors.brown,
              ),
              label: 'Packs'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.how_to_reg,
                color: Colors.brown,
              ),
              label: 'Register'),
        ],
        onTap: (int idx) {
          setState(() {
            _pageIndex = idx;
          });
        },
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.brown,
        selectedItemColor: colors.darkBrown,
        currentIndex: _pageIndex,
      ),
    );
  }
}
