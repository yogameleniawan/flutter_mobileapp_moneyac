import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_utils/date_utils.dart';

class FormTransaction extends StatefulWidget {
  FormTransaction({Key key, this.month, this.year}) : super(key: key);
  String month;
  String year;
  @override
  _FormTransactionState createState() => _FormTransactionState();
}

class _FormTransactionState extends State<FormTransaction> {
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
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: "Name",
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
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: "Email",
                  hintStyle: TextStyle(fontSize: 15),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                ),
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, right: 14, left: 14, bottom: 8),
              child: TextFormField(
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: "Date",
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintStyle: TextStyle(fontSize: 15),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        print(int.parse(widget.year));
                        print(int.parse(widget.month));
                        showDatePicker(
                          context: context,
                          initialDate: DateTime(
                              int.parse(widget.year), int.parse(widget.month)),
                          firstDate: DateTime(
                              int.parse(widget.year), int.parse(widget.month)),
                          lastDate: DateTime(int.parse(widget.year),
                              int.parse(widget.month) + 1, 0),
                        ).then((date) {});
                      },
                      child: Icon(Icons.date_range_rounded),
                    )),
                cursorColor: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
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
                          Icons.email,
                          color: Colors.white,
                        ),
                        Text(
                          'Sign Up with Email',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ))),
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
