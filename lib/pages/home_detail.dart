import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp_moneyac/pages/home_list.dart';
import 'package:mobileapp_moneyac/services/database.dart';
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
  String hasil;
  @override
  Widget build(BuildContext context) {
    void _navigateAndDisplaySelection(BuildContext context) async {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return FormTransaction(
                month: widget.dataMonth, year: widget.year, nameUser: nameUser);
          },
        ),
      );
    }

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
              nameMonth: widget.month,
            )),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 55.0,
        width: 55.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              _navigateAndDisplaySelection(context);
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
  StreamerData({
    Key key,
    this.month,
    this.year,
    this.idDocument,
    this.nameMonth,
  });
  final String idDocument;
  final String month;
  final String nameMonth;
  final String year;
  int totalInflow = 0;
  int totalOutflow = 0;
  @override
  Widget build(BuildContext context) {
    int i = 0;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('transaction/$idDocument/transaction_detail')
          .orderBy('day', descending: false)
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
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");

  int length;

  Future<void> getTransactionLength() async {
    length = await getDocumentLength();
  }

  Future<int> getDocumentLength() async {
    var _myDoc = await FirebaseFirestore.instance
        .collection('transaction/$idDocumentTransaction/transaction_detail')
        .get();
    var _myDocCount = _myDoc.docs;
    return _myDocCount.length;
  }

  @override
  Widget build(BuildContext context) {
    getTransactionLength();
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
                  await FirebaseFirestore.instance
                      .collection(
                          'transaction/$idDocumentTransaction/transaction_detail')
                      .doc(idDocument)
                      .delete();

                  await FirebaseFirestore.instance
                      .collection(
                          'transaction/$idDocumentTransaction/transaction_detail/$idDocument/transaction_list')
                      .get()
                      .then((value) {
                    value.docs.forEach((element) {
                      FirebaseFirestore.instance
                          .collection(
                              'transaction/$idDocumentTransaction/transaction_detail/$idDocument/transaction_list')
                          .doc(element.id)
                          .delete()
                          .then((value) {
                        print("Success!");
                      });
                    });
                  });

                  await Database.updateTransactionFlowMonth(
                    uid: uid,
                    idDocument: idDocumentTransaction,
                    idTransactionMonth: idDocument,
                  );

                  await Database.updateTransactionFlow(
                      idDocument: idDocumentTransaction);

                  if (length <= 1) {
                    await Database.updateTransactionDetailDefault(
                        idDocument: idDocumentTransaction);
                    await Database.updateAmountDefault(uid: uid);
                  }

                  await Database.updateAmountUser(uid: uid);
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
                            document['weekday'].toString() == '7'
                                ? "Sunday"
                                : document['weekday'].toString() == '1'
                                    ? "Monday"
                                    : document['weekday'].toString() == '2'
                                        ? "Tuesday"
                                        : document['weekday'].toString() == '3'
                                            ? "Wednesday"
                                            : document['weekday'].toString() ==
                                                    '4'
                                                ? "Thursday"
                                                : document['weekday']
                                                            .toString() ==
                                                        '5'
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
                        Text(
                            " + Rp. " +
                                formatCurrency.format(document['inflow']),
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Outflow", style: TextStyle(color: Colors.red)),
                        Text(
                            " - Rp. " +
                                formatCurrency.format(document['outflow']),
                            style: TextStyle(color: Colors.red)),
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
                        Text("Total",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text(
                            "Rp. " +
                                formatCurrency.format(
                                    document['inflow'] - document['outflow']),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
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
                inflowDetail: document['inflow'],
                outflowDetail: document['outflow'],
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
