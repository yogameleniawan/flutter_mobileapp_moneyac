import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeDetail extends StatefulWidget {
  HomeDetail({Key key, this.idDocument}) : super(key: key);
  String idDocument;

  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.idDocument),
      ),
    );
  }
}
