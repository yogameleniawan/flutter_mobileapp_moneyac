import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';
import 'form_transaction.dart';

class HomeList extends StatefulWidget {
  HomeList(
      {Key key,
      this.idDocument,
      this.transactionId,
      this.year,
      this.month,
      this.nameUser})
      : super(key: key);
  String idDocument;
  String transactionId;
  String month;
  String year;
  String nameUser;

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
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
              ],
            ),
            Expanded(
                child: StreamerData(
                    month: widget.month,
                    year: widget.year,
                    idDocument: widget.idDocument,
                    transactionId: widget.transactionId)),
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
                        month: widget.month,
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
      {Key key,
      this.month,
      this.year,
      this.idDocument,
      this.nameMonth,
      this.transactionId});
  final String idDocument;
  final String transactionId;
  final String month;
  final String nameMonth;
  final String year;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              'transaction/$transactionId/transaction_detail/$idDocument/transaction_list/')
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
            String idDocumentList = document.id;
            return Container(
              child: ListDataView(
                  document: document,
                  idDocumentTransaction: idDocument,
                  nameMonth: nameMonth,
                  idDocumentList: idDocumentList),
            );
          }).toList(),
        );
      },
    );
  }
}

class ListDataView extends StatelessWidget {
  ListDataView(
      {this.document,
      this.idDocumentTransaction,
      this.nameMonth,
      this.idDocumentList});
  final QueryDocumentSnapshot<Object> document;
  final firestoreInstance = FirebaseFirestore.instance;
  final String idDocumentTransaction;
  final String idDocumentList;
  final String nameMonth;
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");

  @override
  Widget build(BuildContext context) {
    String idTransactionDetail = document['transaction_id'];
    Future<void> _showMyDialog(String listId) async {
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
                  await FirebaseFirestore.instance
                      .collection(
                          'transaction/$idTransactionDetail/transaction_detail/$idDocumentTransaction/transaction_list')
                      .doc(listId)
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                                document['outflow'] == 0
                                    ? Icons.add_circle_outline_sharp
                                    : Icons.remove_circle_outline_sharp,
                                color: document['outflow'] == 0
                                    ? Colors.green
                                    : Colors.red),
                            Text(" " + document['name'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                          ],
                        ),
                        Text(
                            document['inflow'] == 0
                                ? " - Rp. " +
                                    formatCurrency.format(document['outflow'])
                                : " + Rp. " +
                                    formatCurrency.format(document['inflow']),
                            style: document['inflow'] == 0
                                ? TextStyle(color: Colors.red)
                                : TextStyle(color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
      onTap: () {},
      onLongPress: () async {
        _showMyDialog(idDocumentList);
      },
    );
  }
}
