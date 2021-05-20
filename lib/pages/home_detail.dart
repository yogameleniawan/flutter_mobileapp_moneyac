import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'form_transaction.dart';

class HomeDetail extends StatefulWidget {
  HomeDetail({Key key, this.idDocument, this.month, this.year, this.dataMonth})
      : super(key: key);
  String idDocument;
  String month;
  String dataMonth;
  String year;

  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/detail.png")),
                    color: Colors.redAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35, left: 14),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 105, left: 14),
                  child: Container(
                    child: Text(
                      "List Transaction in ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 122, left: 14),
                  child: Container(
                    child: Text(
                      widget.month + " " + widget.year,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 55.0,
        width: 55.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return FormTransaction(
                        month: widget.dataMonth, year: widget.year);
                  },
                ),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
