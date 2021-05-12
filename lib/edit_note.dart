import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'all_notes.dart';

String updateNoteTitle = "";
String updateNoteDescription = "";
final _titleUpdateController = TextEditingController(text: selectedNoteTitle);
final _descriptionUpdateController =
    TextEditingController(text: selectedNoteDescription);

class UpdateNote extends StatefulWidget {
  const UpdateNote({Key key}) : super(key: key);

  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size _size2 = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Note"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: _size2.height * 0.04,
              ),
              Center(
                child: Container(
                  height: _size2.height * 0.09,
                  width: _size2.width * 0.8,
                  child: TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return "Title Can't be Empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    controller: _titleUpdateController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _size2.height * 0.04,
              ),
              Center(
                child: Container(
                  width: _size2.width * 0.8,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: _descriptionUpdateController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _size2.height * 0.04,
              ),
              FloatingActionButton.extended(
                heroTag: 2,
                onPressed: ()async {
                  if (_formKey.currentState.validate()) {
                    try{
                      final result = await InternetAddress.lookup('google.com');
                      if(result.isNotEmpty){
                        setState(() {
                          updateNoteTitle = _titleUpdateController.text;
                          updateNoteDescription = _descriptionUpdateController.text;
                          Map<String, dynamic> updateData = {
                            "title": updateNoteTitle,
                            "description": updateNoteDescription,
                            "time": FieldValue.serverTimestamp(),
                          };

                          FirebaseFirestore.instance
                              .collection("notes")
                              .doc(selectedNoteID)
                              .update(updateData)
                              .then((value) => Navigator.pop(context))
                              .then(
                                (value) =>
                                    Navigator.popAndPushNamed(context, "/home"),
                              );
                          selectedNoteTitle="";
                          selectedNoteDescription="";
                        });
                      }
                    }on SocketException catch(_) {
                      final snackBar = SnackBar(
                        content: Text("no internet connection"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return null;
                    }

                  } else {
                    return null;
                  }
                },
                label: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
