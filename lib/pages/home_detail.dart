import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_moneyac/pages/home_list.dart';
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
                child: StreamerData(
                    month: widget.dataMonth,
                    year: widget.year,
                    idDocument: widget.idDocument,
                    nameMonth: widget.month)),
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
  const StreamerData(
      {Key key, this.month, this.year, this.idDocument, this.nameMonth});
  final String idDocument;
  final String month;
  final String nameMonth;
  final String year;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('transaction/$idDocument/transaction_detail')
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
              child: ListDataView(
                  document: document,
                  idDocumentTransaction: idDocument,
                  nameMonth: nameMonth),
            );
          }).toList(),
        );
      },
    );
  }
}

class ListDataView extends StatelessWidget {
  ListDataView({this.document, this.idDocumentTransaction, this.nameMonth});
  final QueryDocumentSnapshot<Object> document;
  final firestoreInstance = FirebaseFirestore.instance;
  final String idDocumentTransaction;
  final String nameMonth;

  @override
  Widget build(BuildContext context) {
    String idTransactionDetail = document['idDocument'];
    String transactionId = document['transaction_id'];
    Future<void> _showMyDialog(String idDocument) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Remove Report'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [
                  new Text('Are you sure to remove report?'),
                ],
              ),
            ),
            actions: [
              new FlatButton(
                child: new Text('YES'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  print(idDocumentTransaction + "idDocTransaction");
                  print(idDocument + "idDoc");
                  await FirebaseFirestore.instance
                      .collection(
                          'transaction/$idDocumentTransaction/transaction_detail')
                      .doc(idDocument)
                      .delete();
                },
              ),
              new FlatButton(
                child: new Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return InkWell(
      child: Expanded(
          child: Padding(
        padding: EdgeInsets.only(
          top: 10,
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(document['day'].toString(),
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            document['weekday'].toString() == '1'
                                ? "Sunday"
                                : document['weekday'].toString() == '2'
                                    ? "Monday"
                                    : document['weekday'].toString() == '3'
                                        ? "Tuesday"
                                        : document['weekday'].toString() == '4'
                                            ? "Wednesday"
                                            : document['weekday'].toString() ==
                                                    '5'
                                                ? "Thursday"
                                                : document['weekday']
                                                            .toString() ==
                                                        '6'
                                                    ? "Friday"
                                                    : "Saturday",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(nameMonth + " " + document['year']),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Inflow", style: TextStyle(color: Colors.green)),
                        Text(" + Rp. " + document['inflow'].toString(),
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Outflow", style: TextStyle(color: Colors.red)),
                        Text(" - Rp. " + document['outflow'].toString(),
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ),
      )),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeList(
                day: document['day'],
                idDocument: idTransactionDetail,
                month: document['month'],
                year: document['year'],
                transactionId: transactionId,
              );
            },
          ),
        );
      },
      onLongPress: () async {
        _showMyDialog(document['idDocument'].toString());
      },
    );
  }
}
