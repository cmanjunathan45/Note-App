import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String selectedNoteTitle = "";
String selectedNoteDescription = "";
String selectedNoteID = "";

class ViewAll extends StatefulWidget {
  const ViewAll({Key key}) : super(key: key);

  @override
  _ViewAllState createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("All Notes"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("notes")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }


          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Card(
                child: ListTile(
                  title: Text(
                    snapshot.data.docs[index]["title"].toString(),
                  ),
                  onTap: ()async {
                    try{
                      final result = await InternetAddress.lookup('google.com');
                      if(result.isNotEmpty){
                        selectedNoteTitle =
                            snapshot.data.docs[index]["title"].toString();
                        selectedNoteDescription =
                            snapshot.data.docs[index]["description"].toString();
                        selectedNoteID = snapshot.data.docs[index].id;

                        Navigator.pushNamed(context, "/view_note");
                      }
                    }on SocketException catch(_) {
                      final snackBar = SnackBar(
                        content: Text("no internet connection"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return null;
                    }

                  },
                ),
                elevation: 2.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
