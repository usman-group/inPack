import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_pack/user.dart';
import 'package:in_pack/chat_panel.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> bodyWidgets = [ChatPanel(), UserPanel(),];
  int _receivedCounter = 0;
  int _sharedCounter = 0;
  String _pack = '';
  int _pageIndex = 0;

  void _initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp().then((value) { if (kDebugMode) print('Firebase initialised');});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.maps_home_work), label: 'Map')
        ],
        onTap: (int idx){
          setState(() {
            _pageIndex = idx;
          });
        },
        currentIndex: _pageIndex,
      ),
    );
  }
}