import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'all_notes.dart';

class ViewNote extends StatefulWidget {
  const ViewNote({Key key}) : super(key: key);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedNoteTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
            ),
            onPressed: () async{
              try{
                final result = await InternetAddress.lookup('google.com');
                if(result.isNotEmpty){

                  FirebaseFirestore.instance.collection("restore").add({
                    "title": selectedNoteTitle,
                    "description": selectedNoteDescription,
                    "time": FieldValue.serverTimestamp(),
                  });
                  FirebaseFirestore.instance
                      .collection("notes")
                      .doc(selectedNoteID)
                      .delete()
                      .then((value) => Navigator.pop(context))
                      .then((value) => Navigator.pushNamed(context, "/home"));
                }
              }on SocketException catch(_) {
                final snackBar = SnackBar(
                  content: Text("no internet connection"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                return null;
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 10.0,
          ),
          child: Text(
            selectedNoteDescription,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 6,
        onPressed: ()async {
          try{
            final result = await InternetAddress.lookup('google.com');
            if(result.isNotEmpty){
              Navigator.pushNamed(context, "/edit_note");
            }
          }on SocketException catch(_) {
            final snackBar = SnackBar(
              content: Text("no internet connection"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return null;
          }

        },
        child: Icon(
          Icons.edit_outlined,
          size: 40.0,
        ),
        foregroundColor: Colors.yellow,
        backgroundColor: Colors.white,
        elevation: 3.0,
      ),
    );
  }
}
