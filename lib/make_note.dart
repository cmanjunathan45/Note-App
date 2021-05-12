import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'all_notes.dart';

String noteTitle = "";
String noteDescription = "";
final _titleController = TextEditingController(text: selectedNoteTitle);
final _descriptionController =
    TextEditingController(text: selectedNoteDescription);

class EditNote extends StatefulWidget {
  const EditNote({Key key}) : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size _size2 = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Make Note"),
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
                    controller: _titleController,
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
                    controller: _descriptionController,
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
                heroTag: 3,
                onPressed: () async{
                  if (_formKey.currentState.validate()) {

                    try{
                      final result = await InternetAddress.lookup('google.com');
                      if(result.isNotEmpty){
                        setState(() {
                          noteTitle = _titleController.text;
                          noteDescription = _descriptionController.text;

                          FirebaseFirestore.instance.collection("notes").add({
                            "title": noteTitle,
                            "description": noteDescription,
                            "time": FieldValue.serverTimestamp(),
                          }).then(
                                (value) => Navigator.pop(context),
                          );
                          noteTitle = "";
                          noteDescription = "";
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
                label: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
