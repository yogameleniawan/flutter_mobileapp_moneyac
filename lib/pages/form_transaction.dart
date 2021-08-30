import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp_moneyac/services/database.dart';
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
                  docId = uid +
                      selectedDate?.day.toString() +
                      selectedDate?.month.toString() +
                      selectedDate?.year.toString();
                  transactionId = uid +
                      selectedDate?.month.toString() +
                      selectedDate?.year.toString();
                  Database.addTransactionList(
                      transactionId: transactionId,
                      docId: docId,
                      name: nameController.text,
                      uid: uid,
                      inflow: inflow,
                      outflow: outflow,
                      year: selectedDate?.year.toString(),
                      month: selectedDate?.month.toString(),
                      weekday: selectedDate?.weekday.toString(),
                      day: int.parse(selectedDate?.day.toString()));

                  FirebaseFirestore.instance
                      .collection("transaction")
                      .doc(transactionId)
                      .collection("transaction_detail")
                      .doc(docId)
                      .snapshots()
                      .listen((DocumentSnapshot event) async {
                    if (event.exists) {
                      Database.updateTransactionFlowMonth(
                        uid: uid,
                        idDocument: transactionId,
                        idTransactionMonth: docId,
                      );
                      docId = "";
                    } else {
                      Database.setTransactionDetail(
                          transactionId: transactionId,
                          docId: docId,
                          name: nameController.text,
                          uid: uid,
                          inflow: inflow,
                          outflow: outflow,
                          year: selectedDate?.year.toString(),
                          month: selectedDate?.month.toString(),
                          weekday: selectedDate?.weekday.toString(),
                          day: int.parse(selectedDate?.day.toString()),
                          selectedType: selectedType);

                      docId = "";
                    }
                    Database.updateTransactionFlow(idDocument: transactionId);
                    Database.updateAmountUser(uid: uid);
                  });

                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
