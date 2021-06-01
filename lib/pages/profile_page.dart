import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.email, this.nameUser, this.image);
  String email;
  String nameUser;
  String image =
      "https://www.pngkit.com/png/full/281-2812821_user-account-management-logo-user-icon-png.png";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 170.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/content.png")),
                  color: Colors.redAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 250, top: 50),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.image != null ? widget.image : imageUrl,
                  ),
                  radius: 40,
                  backgroundColor: Colors.transparent,
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
                    children: snapshot.data.docs.map((document) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 262, top: 138),
                          child: Text("Profile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)));
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 14, left: 14),
            child: TextFormField(
              enabled: false,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: widget.nameUser,
                hintStyle: TextStyle(fontSize: 15),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 14, left: 14),
            child: TextFormField(
              enabled: false,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: widget.email != null ? widget.email : emailGoogle,
                hintStyle: TextStyle(fontSize: 15),
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              ),
            ),
          ),
          widget.email != null
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 14, left: 14),
                  child: TextFormField(
                    enabled: false,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: "•••••••",
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    ),
                  ),
                )
              : SizedBox(
                  height: 10,
                ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: RaisedButton(
              onPressed: () {
                signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }), ModalRoute.withName('/'));
              },
              color: const Color(0xff26c165),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}
