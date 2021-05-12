import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

String restoreNoteTitle = "";
String restoreNoteDescription = "";
String restoreNoteID = "";

class Trash extends StatefulWidget {
  const Trash({Key key}) : super(key: key);

  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("restore")
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
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        snapshot.data.docs[index]["title"].toString(),
                      ),
                      onTap: () {
                        restoreNoteTitle =
                            snapshot.data.docs[index]["title"].toString();
                        restoreNoteDescription =
                            snapshot.data.docs[index]["description"].toString();
                        restoreNoteID = snapshot.data.docs[index].id;

                        Navigator.pushNamed(context, "/view_note");
                      },
                    ),
                    elevation: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          height: 40.0,
                          width: 40.0,
                          child: FloatingActionButton(
                            heroTag: 4,
                            onPressed: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection("notes")
                                      .add({
                                    "title": snapshot.data.docs[index]["title"]
                                        .toString(),
                                    "description": snapshot
                                        .data.docs[index]["description"]
                                        .toString(),
                                    "time": FieldValue.serverTimestamp(),
                                  }).then(
                                    (value) => FirebaseFirestore.instance
                                        .collection("restore")
                                        .doc(snapshot.data.docs[index].id)
                                        .delete()
                                        .then((value) => Navigator.pop(context))
                                        .then((value) => Navigator.pushNamed(
                                            context, "/home")),
                                  );
                                }
                              } on SocketException catch (_) {
                                final snackBar = SnackBar(
                                  content: Text("no internet connection"),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return null;
                              }
                            },
                            child: Icon(Icons.restore),
                          )),
                      Container(
                          height: 40.0,
                          width: 40.0,
                          child: FloatingActionButton(
                            heroTag: 5,
                            onPressed: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection("restore")
                                      .doc(snapshot.data.docs[index].id)
                                      .delete();
                                }
                              } on SocketException catch (_) {
                                final snackBar = SnackBar(
                                  content: Text("no internet connection"),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return null;
                              }
                            },
                            child: Icon(Icons.delete_forever),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
