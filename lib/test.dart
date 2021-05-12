import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Test extends StatelessWidget {
  const Test({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SnackBarPage(),
    );
  }
}

class SnackBarPage extends StatefulWidget {
  @override
  _SnackBarPageState createState() => _SnackBarPageState();
}

class _SnackBarPageState extends State<SnackBarPage> {
 int check=1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          try {

            final result = await InternetAddress.lookup('google.com');

            if(result.length<0){
              await FirebaseFirestore.instance.collection("notes").add(
                {
                  "title": "noteTitle",
                  "description": "noteDescription",
                  "time": FieldValue.serverTimestamp(),
                },
              );
            }

            final snackBar = SnackBar(
              content: Text("Data Added"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } on SocketException catch(_) {
            final snackBar = SnackBar(
              content: Text("no internet connection"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return null;
          } on HttpException {
            throw ('No Service Found');
          } on FormatException {
            throw ('Invalid Data Format');
          } catch (e) {
            throw (e.message);
          }
        },
        child: Text('Show SnackBar'),
      ),
    );
  }
}
