import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp_moneyac/pages/edit_transaction.dart';
import 'package:mobileapp_moneyac/services/database.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';
import 'form_transaction.dart';

class HomeList extends StatefulWidget {
  HomeList(
      {Key key,
      this.day,
      this.idDocument,
      this.transactionId,
      this.year,
      this.month,
      this.nameUser,
      this.inflowDetail,
      this.outflowDetail})
      : super(key: key);
  int day;
  String idDocument;
  String transactionId;
  String month;
  String year;
  String nameUser;
  int inflowDetail;
  int outflowDetail;

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "List Transaction in ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.day.toString() +
                              " " +
                              (widget.month == "1"
                                  ? "January"
                                  : widget.month == "2"
                                      ? "February"
                                      : widget.month == "3"
                                          ? "March"
                                          : widget.month == "4"
                                              ? "April"
                                              : widget.month == "5"
                                                  ? "Mei"
                                                  : widget.month == "6"
                                                      ? "June"
                                                      : widget.month == "7"
                                                          ? "July"
                                                          : widget.month == "8"
                                                              ? "August"
                                                              : widget.month ==
                                                                      "9"
                                                                  ? "September"
                                                                  : widget.month ==
                                                                          "10"
                                                                      ? "October"
                                                                      : widget.month ==
                                                                              "11"
                                                                          ? "November"
                                                                          : "December") +
                              " " +
                              widget.year,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
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
              transactionId: widget.transactionId,
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
  StreamerData({
    Key key,
    this.month,
    this.year,
    this.idDocument,
    this.nameMonth,
    this.transactionId,
  });
  final String idDocument;
  final String transactionId;
  final String month;
  final String nameMonth;
  final String year;
  int totalInflow = 0;
  int totalOutflow = 0;

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return StreamBuilder(
      stream: Database.readTransactionList(
          transactionId: transactionId,
          idDocument: idDocument,
          month: month,
          year: year,
          uid: uid),
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
                idDocumentList: idDocumentList,
              ),
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
      this.idDocumentList,
      this.inflowDetail,
      this.outflowDetail});
  final QueryDocumentSnapshot<Object> document;
  final firestoreInstance = FirebaseFirestore.instance;
  final String idDocumentTransaction;
  final String idDocumentList;
  final String nameMonth;
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  final int inflowDetail;
  final int outflowDetail;

  int length;

  Future<void> getTransactionLength() async {
    length = await getDocumentLength();
  }

  Future<int> getDocumentLength() async {
    String id = uid + document['month'] + document['year'];
    var _myDoc = await FirebaseFirestore.instance
        .collection(
            'transaction/$id/transaction_detail/$idDocumentTransaction/transaction_list')
        .get();
    var _myDocCount = _myDoc.docs;
    return _myDocCount.length;
  }

  @override
  Widget build(BuildContext context) {
    getTransactionLength();
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
                  await Database.updateTransactionFlowMonth(
                    uid: uid,
                    idDocument: idTransactionDetail,
                    idTransactionMonth: idDocumentTransaction,
                  );

                  await Database.updateTransactionFlow(
                      idDocument: idTransactionDetail);

                  await Database.updateAmountUser(uid: uid);

                  if (length <= 1) {
                    await Database.updateTransactionListDefault(
                        idDocument: idTransactionDetail,
                        idDocumentDetail: idDocumentTransaction);
                  }
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
                            Text(
                                document['outflow'] == 0
                                    ? " Inflow"
                                    : " Outflow",
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
                    Divider(),
                    Text(
                      "Transaction Name :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(document['name'],
                        style: TextStyle(color: Colors.black54, fontSize: 16))
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
              return EditTransaction(
                  idDocumentList: idDocumentList,
                  nameList: document['name'],
                  amount: document['inflow'] != 0
                      ? document['inflow']
                      : document['outflow'],
                  selectedItem: document['inflow'] != 0 ? "Inflow" : "Outflow",
                  idDocumentDetail: document['idDocument'],
                  idDocumentTransaction: document['transaction_id']);
            },
          ),
        );
      },
      onLongPress: () async {
        _showMyDialog(idDocumentList);
      },
    );
  }
}
