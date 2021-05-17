import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_moneyac/pages/profile_page.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

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
  String image =
      "https://www.pngkit.com/png/full/281-2812821_user-account-management-logo-user-icon-png.png";
  User user;
  int _currentIndex = 0;
  int total = 0;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  Widget readItems() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('transaction')
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
            // setState(() {
            var temp = document['inflow'] - document['outflow'];
            total = total + temp;
            // });
            return null;
          }).toList(),
        );
      },
    );
  }

  Widget readName() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: snapshot.data.docs.map((document) {
            return Text(document['name']);
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String nameUser;

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
                    margin: EdgeInsets.only(top: 40, left: 15, right: 15),
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
                                          nameUser = document['name'];
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
                                  const EdgeInsets.only(top: 30, left: 160.0),
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
                                  Text(
                                    "Rp. " + total.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                              StreamerData(month: "january"),
                              StreamerData(month: "february"),
                              StreamerData(month: "march"),
                              StreamerData(month: "april"),
                              StreamerData(month: "mei"),
                              StreamerData(month: "june"),
                              StreamerData(month: "july"),
                              StreamerData(month: "august"),
                              StreamerData(month: "september"),
                              StreamerData(month: "october"),
                              StreamerData(month: "november"),
                              StreamerData(month: "december"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ProfilePage(this.email, nameUser, this.image),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
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
            onPressed: () {},
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            // elevation: 5.0,
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
    FirebaseFirestore firestrore = FirebaseFirestore.instance;
    CollectionReference transaction = firestrore.collection('transaction');
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('transaction')
          .where('month', isEqualTo: month)
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
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  final firestoreInstance = FirebaseFirestore.instance;
  int total = 0;

  @override
  Widget build(BuildContext context) {
    total += document['inflow'] + total;
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
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Inflow"),
                    Text(
                      "Rp. " + formatCurrency.format(document['inflow']),
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Outflow"),
                      Text(
                        "Rp. " + formatCurrency.format(document['outflow']),
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
      onTap: () {},
    );
  }
}