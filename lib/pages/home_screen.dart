import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileapp_moneyac/pages/login_page.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';

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

  int _currentIndex = 0;
  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
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
                                  Text(name != null ? name : nameGoogle)
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
                                    "Rp. 1.500.000",
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
                              January(),
                              Expanded(child: Text("2")),
                              Expanded(child: Text("3")),
                              Expanded(child: Text("4")),
                              Expanded(child: Text("5")),
                              Expanded(child: Text("6")),
                              Expanded(child: Text("7")),
                              Expanded(child: Text("8")),
                              Expanded(child: Text("9")),
                              Expanded(child: Text("10")),
                              Expanded(child: Text("11")),
                              Expanded(child: Text("12")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Text("Text Kosong"),
            ),
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
            icon: Icon(Icons.add_box),
            title: Text('Add'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
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

class January extends StatelessWidget {
  const January({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
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
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Overview 2020",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "Tap to view full report",
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Inflow"),
                          Text(
                            "Rp. 70.000",
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
                              "Rp. 20.000",
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
                              "Rp. 50.000",
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
        },
      ),
    );
  }
}
