import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';
import 'package:date_utils/date_utils.dart';

class FormTransaction extends StatefulWidget {
  FormTransaction({Key key, this.month, this.year, this.nameUser})
      : super(key: key);
  String nameUser;
  String month;
  String year;

  @override
  _FormTransactionState createState() => _FormTransactionState();
}

class _FormTransactionState extends State<FormTransaction> {
  DateTime selectedDate;
  String docId;
  String transactionId;
  String _chosenValue;
  int inflow;
  int outflow;
  final Map<String, IconData> _data = Map.fromIterables([
    'Please choose Inflow/Outflow',
    'Inflow',
    'Outflow'
  ], [
    Icons.search,
    Icons.add_circle_outline_sharp,
    Icons.remove_circle_outline_sharp
  ]);
  String selectedType;
  IconData _selectedIcon;
  TextEditingController dateController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff26c165),
        title: Text("Add Transaction"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 14, left: 14),
              child: TextFormField(
                controller: nameController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: "Name Transaction",
                  hintStyle: TextStyle(fontSize: 15),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                ),
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, right: 14, left: 14, bottom: 8),
              child: TextFormField(
                controller: totalController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: "Total Value",
                  labelText: "Amount",
                  hintStyle: TextStyle(fontSize: 15),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                ),
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, right: 14, left: 14, bottom: 8),
              child: TextFormField(
                readOnly: true,
                controller: dateController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: "Date",
                    labelText: "Day",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime(
                              int.parse(widget.year), int.parse(widget.month)),
                          firstDate: DateTime(
                              int.parse(widget.year), int.parse(widget.month)),
                          lastDate: DateTime(int.parse(widget.year),
                              int.parse(widget.month) + 1, 0),
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                              dateController.text =
                                  DateFormat('dd').format(selectedDate);
                            });
                          }
                        });
                      },
                      child: Icon(Icons.date_range_rounded),
                    )),
                cursorColor: Colors.black,
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      items: _data.keys.map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Icon(_data[val]),
                              ),
                              Text(val),
                            ],
                          ),
                        );
                      }).toList(),
                      hint: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Icon(
                              _selectedIcon ?? _data.values.toList()[0],
                              color: _selectedIcon ==
                                      Icons.remove_circle_outline_sharp
                                  ? Colors.red
                                  : _selectedIcon ==
                                          Icons.add_circle_outline_sharp
                                      ? Colors.green
                                      : Colors.black54,
                            ),
                          ),
                          Text(
                            selectedType ?? _data.keys.toList()[0],
                            style: TextStyle(
                                color: selectedType == "Outflow"
                                    ? Colors.red
                                    : selectedType == "Inflow"
                                        ? Colors.green
                                        : Colors.black54),
                          ),
                        ],
                      ),
                      onChanged: (String val) {
                        setState(() {
                          selectedType = val;
                          _selectedIcon = _data[val];
                        });
                        if (selectedType == "Inflow") {
                          setState(() {
                            inflow = int.parse(totalController.text);
                            outflow = 0;
                          });
                        } else if (selectedType == "Outflow") {
                          setState(() {
                            outflow = int.parse(totalController.text);
                            inflow = 0;
                          });
                        }
                      }),
                ),
              ),
            ),
            InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff26c165)),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.add_box,
                          color: Colors.white,
                        ),
                        Text(
                          'Add Transaction',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ))),
                onTap: () {
                  if (widget.nameUser.contains(" ")) {
                    widget.nameUser = widget.nameUser
                        .substring(0, widget.nameUser.indexOf(" "));
                  }
                  docId = widget.nameUser +
                      selectedDate?.day.toString() +
                      selectedDate?.month.toString() +
                      selectedDate?.year.toString();
                  transactionId = widget.nameUser +
                      selectedDate?.month.toString() +
                      selectedDate?.year.toString();
                  FirebaseFirestore.instance
                      .collection("transaction")
                      .doc(transactionId)
                      .collection("transaction_detail")
                      .doc(docId)
                      .snapshots()
                      .listen((DocumentSnapshot event) {
                    if (event.exists) {
                      CollectionReference<Map<String, dynamic>> transactions =
                          FirebaseFirestore.instance.collection(
                              "transaction/$transactionId/transaction_detail/$docId/transaction_list");
                      var data = {
                        'idDocument': docId,
                        'name': nameController.text,
                        'uid': uid,
                        'inflow': inflow,
                        'outflow': outflow,
                        'year': selectedDate?.year.toString(),
                        'weekday': selectedDate?.weekday.toString(),
                        'month': selectedDate?.month.toString(),
                        'day': selectedDate?.day.toString(),
                        'transaction_id': transactionId
                      };
                      transactions
                          .add(data)
                          .then((value) =>
                              print("Transaction with CustomID added"))
                          .catchError((error) =>
                              print("Failed to add transaction: $error"));
                      /////
                      DocumentReference<Map<String, dynamic>>
                          transaction_amount = FirebaseFirestore.instance
                              .collection("transaction")
                              .doc(transactionId)
                              .collection("transaction_detail")
                              .doc(docId);
                      int inflowDetail = event.get('inflow');
                      int inflowTotal = inflow + inflowDetail;
                      int outflowDetail = event.get('outflow');
                      int outflowTotal = outflow + outflowDetail;
                      if (selectedType == "Inflow") {
                        var dataInflow = {
                          'inflow': inflowTotal,
                          'outflow': event.get('outflow'),
                        };
                        transaction_amount
                            .update(dataInflow)
                            .then((value) =>
                                print("Transaction with CustomID added"))
                            .catchError((error) =>
                                print("Failed to add transaction: $error"));
                      } else if (selectedType == "Outflow") {
                        var dataOutflow = {
                          'inflow': event.get('inflow'),
                          'outflow': outflowTotal,
                        };
                        transaction_amount
                            .update(dataOutflow)
                            .then((value) =>
                                print("Transaction with CustomID added"))
                            .catchError((error) =>
                                print("Failed to add transaction: $error"));
                      }
                      ////////////////
                      docId = "";
                    } else {
                      DocumentReference<Map<String, dynamic>>
                          transaction_detail = FirebaseFirestore.instance
                              .collection("transaction")
                              .doc(transactionId)
                              .collection("transaction_detail")
                              .doc(docId);
                      var dataDetail = {
                        'idDocument': docId,
                        'uid': uid,
                        'inflow': inflow,
                        'outflow': outflow,
                        'year': selectedDate?.year.toString(),
                        'weekday': selectedDate?.weekday.toString(),
                        'month': selectedDate?.month.toString(),
                        'day': selectedDate?.day.toString(),
                        'transaction_id': transactionId
                      };
                      transaction_detail
                          .set(dataDetail)
                          .then((value) =>
                              print("Transaction with CustomID added"))
                          .catchError((error) =>
                              print("Failed to add transaction: $error"));

                      CollectionReference<Map<String, dynamic>> transactions =
                          FirebaseFirestore.instance.collection(
                              "transaction/$transactionId/transaction_detail/$docId/transaction_list");
                      var data = {
                        'idDocument': docId,
                        'name': nameController.text,
                        'uid': uid,
                        'inflow': inflow,
                        'outflow': outflow,
                        'year': selectedDate?.year.toString(),
                        'weekday': selectedDate?.weekday.toString(),
                        'month': selectedDate?.month.toString(),
                        'day': selectedDate?.day.toString(),
                        'transaction_id': transactionId
                      };
                      transactions
                          .add(data)
                          .then((value) =>
                              print("Transaction with CustomID added"))
                          .catchError((error) =>
                              print("Failed to add transaction: $error"));

                      docId = "";
                    }
                  });
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
