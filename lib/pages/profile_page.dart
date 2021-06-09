import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_moneyac/services/database.dart';
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
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String name;
  String email;
  bool passwordVisible = false;
  @override
  void initState() {
    readUser(uid: uid);
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    super.initState();
  }

  Future<void> readUser({String uid}) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((value) async {
      setState(() {
        name = value.get("name");
        email = value.get("email");
      });
    });
  }

  Future<void> showUpdateName() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Update Name'),
          content: new SingleChildScrollView(
            child: TextFormField(
              controller: nameController,
            ),
          ),
          actions: [
            new FlatButton(
                child: new Text('Update'),
                onPressed: () async {
                  if (nameController.text == "") {
                    final snackBar = SnackBar(
                      content: Text('Not allowed empty input.'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  } else {
                    Database.updateNameUser(
                        uid: uid, name: nameController.text);
                    final snackBar = SnackBar(
                      content: Text('Name Was Updated'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }
                }),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showUpdateEmail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Update Email'),
          content: new SingleChildScrollView(
            child: TextFormField(
              controller: emailController,
            ),
          ),
          actions: [
            new FlatButton(
                child: new Text('Update Email'),
                onPressed: () async {
                  User user = await FirebaseAuth.instance.currentUser;
                  user.updateEmail(emailController.text);
                  user.updateEmail(emailController.text).then((_) {
                    print("Successfully changed email");
                    Database.updateEmailUser(
                        uid: uid, email: emailController.text);
                    final snackBar = SnackBar(
                      content: Text('Email Was Updated'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    print("Email can't be changed" + error.toString());
                    if (error.code == 'requires-recent-login') {
                      final snackBar = SnackBar(
                        content: Text(
                            "Requires recent authentication. Log in again before retrying this request."),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    } else if (error.code == 'email-already-in-use') {
                      final snackBar = SnackBar(
                        content: Text(
                            "The email address is already in use by another account."),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    } else if (error.code == 'invalid-email') {
                      final snackBar = SnackBar(
                        content: Text("The email address is badly formatted."),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }
                  });
                }),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showUpdatePassword() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Update Password'),
          content: new SingleChildScrollView(
            child: TextFormField(
              controller: passwordController,
              obscureText: !passwordVisible,
            ),
          ),
          actions: [
            new FlatButton(
                child: new Text('Update Password'),
                onPressed: () async {
                  User user = await FirebaseAuth.instance.currentUser;
                  user.updatePassword(passwordController.text);

                  user.updatePassword(passwordController.text).then((_) {
                    print("Successfully changed password");
                    final snackBar = SnackBar(
                      content: Text('Password Was Updated'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    print("Password can't be changed" + error.toString());
                    if (error.code == 'weak-password') {
                      final snackBar = SnackBar(
                        content:
                            Text("Password is weak, password not updated."),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    } else if (error.code == 'requires-recent-login') {
                      final snackBar = SnackBar(
                        content: Text(
                            "Requires recent authentication. Log in again before retrying this request."),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    } else if (error.code == 'unknown') {
                      final snackBar = SnackBar(
                        content: Text(
                            "Password Not Allowed Given String is empty or null"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    }
                  });
                }),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          emailGoogle == ""
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 14, left: 14),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        hintText: name,
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            showUpdateName();
                          },
                          child: Icon(Icons.edit),
                        )),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 14, left: 14),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: name,
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    ),
                  ),
                ),
          emailGoogle == ""
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 14, left: 14),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        hintText: email,
                        hintStyle: TextStyle(fontSize: 15),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            showUpdateEmail();
                          },
                          child: Icon(Icons.edit),
                        )),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 14, left: 14),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hintText: email,
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    ),
                  ),
                ),
          emailGoogle == ""
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 14, left: 14),
                  child: TextFormField(
                    readOnly: true,
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
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            showUpdatePassword();
                          },
                          child: Icon(Icons.edit),
                        )),
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
