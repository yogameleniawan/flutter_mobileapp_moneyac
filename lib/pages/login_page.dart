import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp_moneyac/pages/home_screen.dart';
import 'package:mobileapp_moneyac/pages/register_page.dart';
import 'package:mobileapp_moneyac/services/sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  bool passwordVisible = false;
  User user;

  String error = "";
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestrore = FirebaseFirestore.instance;
    CollectionReference users = firestrore.collection('users');
    return Scaffold(
      // backgroundColor: const Color(0xff26c165),
      // resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/background.png"), //Image Asset Background Image
                fit: BoxFit.cover)),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Image(image: AssetImage("assets/logo.png"), height: 110.0),
                SizedBox(height: 25),
                Container(
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5, left: 10, right: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 25),
                              ),
                            ),
                            Text(
                                errorMessageLogin != null
                                    ? errorMessageLogin
                                    : "",
                                style: TextStyle(color: Colors.red)),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 14, left: 14, bottom: 8),
                              child: TextFormField(
                                validator: (value) =>
                                    EmailValidator.validate(value)
                                        ? null
                                        : "Please enter a valid email",
                                controller: emailController,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(fontSize: 15),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                ),
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, right: 14, left: 14, bottom: 8),
                              child: TextFormField(
                                validator: (value) {
                                  // add your custom validation here.
                                  if (value.isEmpty) {
                                    return 'Empty Field, Please enter some text';
                                  }
                                },
                                controller: passwordController,
                                obscureText: !passwordVisible,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  hintText: "Password",
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintStyle: TextStyle(fontSize: 15),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    child: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: passwordVisible
                                          ? Colors.blue
                                          : Color(0xFFE6E6E6),
                                    ),
                                  ),
                                ),
                                cursorColor: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            InkWell(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height:
                                        MediaQuery.of(context).size.height / 18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xFF131a22)),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(
                                          Icons.email,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Sign in with Email',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ))),
                                onTap: () async {
                                  signInWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text)
                                      .then((result) {
                                    if (result != null) {
                                      String email = result.email;
                                      String name = "User";
                                      String image =
                                          "https://www.pngkit.com/png/full/281-2812821_user-account-management-logo-user-icon-png.png";
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return HomeScreen(
                                                email: email,
                                                name: name,
                                                image: image);
                                          },
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        errorMessageLogin = errorMessageLogin;
                                      });
                                    }
                                  });
                                }),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",
                          style: TextStyle(color: Colors.white)),
                      Text(
                        " SIGN UP",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterPage();
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _signInButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    FirebaseFirestore firestrore = FirebaseFirestore.instance;

    return InkWell(
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 18,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image(
                      image: AssetImage("assets/google-logo.png"),
                      height: 35.0),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ))),
        onTap: () {
          signInWithGoogle().then((result) {
            // CollectionReference<Map<String, dynamic>> users =
            //     FirebaseFirestore.instance.collection('/users/$uid');
            // var user = {
            //   'uid': uid,
            //   'name': nameGoogle,
            //   'email': emailGoogle,
            //   'imageUrl': imageUrl,
            //   'totalAmount': 0
            // };
            // users
            //     .add(user)
            //     .then((value) => print("User with CustomID added"))
            //     .catchError((error) => print("Failed to add user: $error"));
            if (result != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen();
                  },
                ),
              );
            }
          });
        });
  }
}
