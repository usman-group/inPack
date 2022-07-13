import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_pack/pages/chat_page.dart';
import 'package:in_pack/pages/list_page.dart';
import 'package:in_pack/pages/registration_page.dart';
import 'package:in_pack/pages/user_page.dart';
import 'package:in_pack/widgets/bottom_navbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ));

    bodyWidgets = [
      const ChatPanel(),
      const UserPanel(),
      const ListPanel(),
      const RegisterPage(),
    ];

    super.initState();
  }

  late List<Widget> bodyWidgets;
  int _pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {});
    });
    return Scaffold(
        backgroundColor: const Color(0xFF6E4B3F),
        appBar: AppBar(
          title: const Icon(Icons.smoking_rooms),
          centerTitle: true,
          backgroundColor: Colors.black38,
        ),
        body: FirebaseAuth.instance.currentUser == null
            ? const RegisterPage()
            : bodyWidgets[_pageIndex],
        bottomNavigationBar: BottomNavbar(
          onTap: (idx) => setState(() {
            _pageIndex = idx;
          }),
          currentIndex: _pageIndex,
        ));
  }
}
