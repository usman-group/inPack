import 'package:flutter/material.dart';
import 'package:in_pack/chat_panel.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:in_pack/user.dart';
import 'package:in_pack/list_panel.dart';
import 'package:in_pack/colors.dart' as colors;
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    const ListPanel()
  ];
  int _receivedCounter = 0;
  int _sharedCounter = 0;
  String _pack = '';
  int _pageIndex = 0;

  void _initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) { if (kDebugMode) print('Firebase initialised $value');});
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
        )
    );
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
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined, color: Colors.white,), label: 'Chat', backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white,), label: 'User',),
          BottomNavigationBarItem(
              icon: Icon(Icons.list, color: Colors.white,), label: 'Packs'),
        ],
        onTap: (int idx){
          setState(() {
            _pageIndex = idx;
          });
        },
        backgroundColor: colors.darkBrown,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.purpleAccent,
        currentIndex: _pageIndex,
      ),
    );
  }
}


