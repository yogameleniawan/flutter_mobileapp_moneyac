import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileapp_moneyac/services/database.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';

class EditTransaction extends StatefulWidget {
  EditTransaction(
      {Key key,
      this.nameUser,
      this.idDocumentList,
      this.nameList,
      this.amount,
      this.selectedItem,
      this.idDocumentDetail,
      this.idDocumentTransaction})
      : super(key: key);
  String nameUser;

  int amount;

  String idDocumentList;
  String idDocumentDetail;
  String idDocumentTransaction;
  String nameList;
  String selectedItem;

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  String docId;
  String transactionId;
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
  TextEditingController nameController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.nameList;
    totalController.text = widget.amount.toString();
    selectedType = widget.selectedItem;
    _selectedIcon = widget.selectedItem == "Inflow"
        ? Icons.add_circle_outline_sharp
        : Icons.remove_circle_outline_sharp;
    inflow = widget.selectedItem == "Inflow" ? widget.amount : 0;
    outflow = widget.selectedItem == "Outflow" ? widget.amount : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff26c165),
        title: Text("Edit Transaction"),
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
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          'Edit Transaction',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ))),
                onTap: () {
                  DocumentReference<Map<String, dynamic>> transaction_amount =
                      FirebaseFirestore.instance
                          .collection("transaction")
                          .doc(widget.idDocumentTransaction)
                          .collection("transaction_detail")
                          .doc(widget.idDocumentDetail)
                          .collection("transaction_list")
                          .doc(widget.idDocumentList);
                  if (selectedType == "Inflow") {
                    var dataInflow = {
                      'name': nameController.text,
                      'inflow': int.parse(totalController.text),
                      'outflow': outflow,
                    };
                    transaction_amount
                        .update(dataInflow)
                        .then(
                            (value) => print("Transaction with CustomID added"))
                        .catchError((error) =>
                            print("Failed to add transaction: $error"));
                    Database.updateTransactionFlowMonth(
                      uid: uid,
                      idDocument: widget.idDocumentTransaction,
                      idTransactionMonth: widget.idDocumentDetail,
                    );

                    Database.updateTransactionFlow(
                        idDocument: widget.idDocumentTransaction);

                    Database.updateAmountUser(uid: uid);
                  } else if (selectedType == "Outflow") {
                    var dataOutflow = {
                      'name': nameController.text,
                      'inflow': inflow,
                      'outflow': int.parse(totalController.text),
                    };
                    transaction_amount
                        .update(dataOutflow)
                        .then(
                            (value) => print("Transaction with CustomID added"))
                        .catchError((error) =>
                            print("Failed to add transaction: $error"));
                    Database.updateTransactionFlowMonth(
                      uid: uid,
                      idDocument: widget.idDocumentTransaction,
                      idTransactionMonth: widget.idDocumentDetail,
                    );

                    Database.updateTransactionFlow(
                        idDocument: widget.idDocumentTransaction);

                    Database.updateAmountUser(uid: uid);
                  }

                  Navigator.pop(context, 'Added');
                }),
          ],
        ),
      ),
    );
  }
}
