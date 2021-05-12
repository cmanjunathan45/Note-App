import 'dart:io';

import 'package:flutter/material.dart';

import 'all_notes.dart';
import 'trash.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTab = 0;
  final _pageOptions = [
    ViewAll(),
    Trash(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pageOptions[_selectedTab],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 1,
        onPressed: ()async {
          try{
            final result = await InternetAddress.lookup('google.com');
            if(result.isNotEmpty){Navigator.pushNamed(context, "/make_note");}
          }
          on SocketException catch(_) {
            final snackBar = SnackBar(
              content: Text("no internet connection"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return null;
          }



        },
        child: Icon(Icons.add,size: 40.0,),
        foregroundColor: Colors.yellow,
        backgroundColor: Colors.white,
        elevation: 3.0,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 2.0,

        child: SizedBox(
          height: 80,
          child: Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.yellow,
                primaryColor: Colors.white,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.white))),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedTab,
              onTap: (int index) async{
              try{
                final result = await InternetAddress.lookup('google.com');
                setState(() {
                  if(result.isNotEmpty){
                    _selectedTab = index;
                  }
                });
              }
              on SocketException catch(_) {
                final snackBar = SnackBar(
                  content: Text("No internet connection"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return null;
              }
              },
              fixedColor: Colors.white,
              items: [

                BottomNavigationBarItem(

                    icon: Icon(Icons.view_sidebar_rounded),
                    title: Text('View All')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.delete_outline),
                    title: Text('Trash')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
