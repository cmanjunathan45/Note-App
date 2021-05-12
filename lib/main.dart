import 'dart:io';

import 'package:flutter/material.dart';
import 'test.dart';
import 'all_notes.dart';
import 'view_note.dart';
import 'make_note.dart';
import 'edit_note.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      // home: check == 1 ? Home() :check==0? Test():Test(),
      routes: {
        "/home": (context) => Home(),
        "/edit_note": (context) => UpdateNote(),
        "/make_note": (context) => EditNote(),
        "/view_note": (context) => ViewNote(),
        "/view_all": (context) => ViewAll(),
        "/test": (context) => Test(),
      },
      color: Colors.yellow,
    );
  }
}
