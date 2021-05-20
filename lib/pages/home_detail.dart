import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';
import 'form_transaction.dart';

class HomeDetail extends StatefulWidget {
  HomeDetail(
      {Key key,
      this.idDocument,
      this.month,
      this.year,
      this.dataMonth,
      this.nameUser})
      : super(key: key);
  String idDocument;
  String month;
  String dataMonth;
  String year;
  String nameUser;

  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  String nameUser;
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
                  padding: const EdgeInsets.only(top: 80, left: 120),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('uid', isEqualTo: uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: snapshot.data.docs.map((document) {
                          nameUser = document['name'];
                          return Text(" | " + document['name'],
                              style: TextStyle(color: Colors.white));
                        }).toList(),
                      );
                    },
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
            Expanded(
                child:
                    StreamerData(month: widget.dataMonth, year: widget.year)),
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
                        month: widget.dataMonth,
                        year: widget.year,
                        nameUser: nameUser);
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

class StreamerData extends StatelessWidget {
  const StreamerData({Key key, this.month, this.year});
  final String month;
  final String year;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestrore = FirebaseFirestore.instance;
    CollectionReference transaction =
        firestrore.collection('transaction_detail');
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('transaction_detail')
          .where('month', isEqualTo: month)
          .where('year', isEqualTo: year)
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data.docs.map((document) {
            return Container(
              child: ListDataView(document: document),
            );
          }).toList(),
        );
      },
    );
  }
}

class ListDataView extends StatelessWidget {
  ListDataView({this.document});
  final QueryDocumentSnapshot<Object> document;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Expanded(
          child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 5,
          right: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
                bottomLeft: Radius.circular(2),
                bottomRight: Radius.circular(2)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(document['inflow'].toString()),
                Text(document['name'])
              ],
            ),
          ),
        ),
      )),
      onTap: () {},
    );
  }
}
