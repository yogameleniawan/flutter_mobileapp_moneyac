import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_moneyac/pages/home_detail.dart';
import 'package:mobileapp_moneyac/pages/profile_page.dart';
import 'package:mobileapp_moneyac/services/database.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.email, this.name, this.image});
  String email;
  String name;
  String image;

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(this.email, this.name, this.image);
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _myPage = PageController(initialPage: 0);
  _HomeScreenState(this.email, this.name, this.image);
  String email;
  String name;
  String nameUser;
  String image =
      "https://www.pngkit.com/png/full/281-2812821_user-account-management-logo-user-icon-png.png";
  User user;
  int _currentIndex = 0;
  int total;
  DateTime initialDate = DateTime.now();
  DateTime selectedDate;
  String docId = "";
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  @override
  void initState() {
    super.initState();
    selectedDate = initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
          controller: _myPage,
          onPageChanged: (int) {
            print('Page Changes to index $int');
          },
          children: <Widget>[
            Container(
              child: DefaultTabController(
                length: 12,
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hello!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  StreamBuilder(
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
                                        children:
                                            snapshot.data.docs.map((document) {
                                          return Text(document['name']);
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    image != null ? image : imageUrl,
                                  ),
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Stack(children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 150.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/content.png")),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                color: Colors.redAccent,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 25, left: 160.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Amount",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  StreamBuilder(
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
                                        children:
                                            snapshot.data.docs.map((document) {
                                          return Text(
                                            "Rp. " +
                                                formatCurrency.format(
                                                    document['totalAmount']),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                  Text(
                                    "\n\nNever Spend Your Money Before You Have Earned It.",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                        TabBar(
                          isScrollable: true,
                          indicatorColor: const Color(0xff26c165),
                          unselectedLabelColor: Colors.black,
                          labelColor: const Color(0xff26c165),
                          tabs: [
                            new Container(
                              child: new Tab(text: 'January'),
                            ),
                            new Container(
                              child: new Tab(text: 'February'),
                            ),
                            new Container(
                              child: new Tab(text: 'March'),
                            ),
                            new Container(
                              child: new Tab(text: 'April'),
                            ),
                            new Container(
                              child: new Tab(text: 'Mei'),
                            ),
                            new Container(
                              child: new Tab(text: 'June'),
                            ),
                            new Container(
                              child: new Tab(text: 'July'),
                            ),
                            new Container(
                              child: new Tab(text: 'August'),
                            ),
                            new Container(
                              child: new Tab(text: 'September'),
                            ),
                            new Container(
                              child: new Tab(text: 'October'),
                            ),
                            new Container(
                              child: new Tab(text: 'November'),
                            ),
                            new Container(
                              child: new Tab(text: 'December'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // first tab bar view widget
                              StreamerData(month: "1"),
                              StreamerData(month: "2"),
                              StreamerData(month: "3"),
                              StreamerData(month: "4"),
                              StreamerData(month: "5"),
                              StreamerData(month: "6"),
                              StreamerData(month: "7"),
                              StreamerData(month: "8"),
                              StreamerData(month: "9"),
                              StreamerData(month: "10"),
                              StreamerData(month: "11"),
                              StreamerData(month: "12"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ProfilePage(this.email, this.nameUser, this.image),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
      floatingActionButton: Container(
        height: 55.0,
        width: 55.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              showMonthPicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 10, 5),
                lastDate: DateTime(DateTime.now().year + 10, 9),
                initialDate: selectedDate ?? initialDate,
                locale: Locale("en"),
              ).then((date) {
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
                docId = uid +
                    selectedDate?.month.toString() +
                    selectedDate?.year.toString();
                FirebaseFirestore.instance
                    .collection("transaction")
                    .doc(docId)
                    .snapshots()
                    .listen((DocumentSnapshot event) {
                  if (event.exists) {
                    Database.updateTransaction(
                        docId: docId,
                        idDocument: event.get("idDocument"),
                        uid: event.get("uid"),
                        inflow: event.get("inflow"),
                        outflow: event.get("outflow"),
                        year: event.get("year"),
                        month: event.get("month"));
                    docId = "";
                  } else {
                    Database.updateTransaction(
                        docId: docId,
                        idDocument: docId,
                        uid: uid,
                        inflow: 0,
                        outflow: 0,
                        year: selectedDate?.year.toString(),
                        month: selectedDate?.month.toString());
                    docId = "";
                  }
                });
              });
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _myPage.jumpToPage(_currentIndex);
    });
  }
}

class StreamerData extends StatelessWidget {
  const StreamerData({Key key, this.month});
  final String month;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Database.readTransaction(month: month, uid: uid),
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
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  final firestoreInstance = FirebaseFirestore.instance;
  int length;

  Future<void> getTransactionLength() async {
    length = await getDocumentLength();
  }

  Future<int> getDocumentLength() async {
    var _myDoc =
        await FirebaseFirestore.instance.collection('transaction').get();
    var _myDocCount = _myDoc.docs;
    return _myDocCount.length;
  }

  @override
  Widget build(BuildContext context) {
    getTransactionLength();
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
                  await Database.deleteTransaction(idDocument: idDocument);
                  await Database.deleteAllTransactionDetail(
                      idDocument: idDocument);
                  await Database.updateAmountUser(uid: uid);
                  if (length <= 1) {
                    await Database.updateAmountDefault(uid: uid);
                  }
                },
              ),
              new FlatButton(
                child: new Text('NO'),
                onPressed: () async {
                  print(length);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    String idDocument = document['idDocument'];
    String month;
    String year = document['year'];
    String dataMonth = document['month'];

    if (document['month'] == "1") {
      month = "January";
    } else if (document['month'] == "2") {
      month = "February";
    } else if (document['month'] == "3") {
      month = "March";
    } else if (document['month'] == "4") {
      month = "April";
    } else if (document['month'] == "5") {
      month = "Mei";
    } else if (document['month'] == "6") {
      month = "June";
    } else if (document['month'] == "7") {
      month = "July";
    } else if (document['month'] == "8") {
      month = "August";
    } else if (document['month'] == "9") {
      month = "September";
    } else if (document['month'] == "10") {
      month = "October";
    } else if (document['month'] == "11") {
      month = "November";
    } else if (document['month'] == "12") {
      month = "December";
    }

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
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/head.png")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35, left: 10),
                      child: Text("Overview " + document['year'],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 10),
                      child: Text(
                        "Tap to view full report",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80, left: 12),
                      child: Text(
                        "Long press to delete report",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Inflow", style: TextStyle(color: Colors.green)),
                    Text("Rp. " + formatCurrency.format(document['inflow']),
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Outflow", style: TextStyle(color: Colors.red)),
                      Text("Rp. " + formatCurrency.format(document['outflow']),
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "Rp. " +
                            formatCurrency.format(
                                document['inflow'] - document['outflow']),
                        style: (document['inflow'] - document['outflow']) == 0
                            ? TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)
                            : document['inflow'] - document['outflow'] < 0
                                ? TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)
                                : TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                      ),
                    ],
                  ),
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
              return HomeDetail(
                idDocument: idDocument,
                month: month,
                year: year,
                dataMonth: dataMonth,
              );
            },
          ),
        );
      },
      onLongPress: () async {
        _showMyDialog(idDocument);
      },
    );
  }
}
