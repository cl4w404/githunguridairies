import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:g_dairies/admin/admin_index.dart';
import 'package:g_dairies/congig.dart';
import 'package:g_dairies/keys.dart';
import 'package:g_dairies/screens/landin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthClass authClass = AuthClass();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _pwdControllerPhone = new TextEditingController();
  TextEditingController _emailControllerPhone = new TextEditingController();
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue.shade50,
      body: currentWidth < 700
          ? Stack(
              children: [
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height:50,
                            width: 150,
                            child: Image.asset('assets/white.png')),
                        SizedBox(
                          height: 10,
                        ),

                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Container(
                        width: 320,
                        height: 360,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.black,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.0),
                                child: Container(
                                  height: 2.0,
                                  width: 115.0,
                                  color: Colors.blue.shade50,
                                ),
                              ),


                              SizedBox(
                                height: 5,
                              ),

                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: (email) => email != null &&
                                                !EmailValidator.validate(email)
                                            ? 'Enter a valid email'
                                            : null,
                                        controller: _emailControllerPhone,
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.blue.shade900,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 40.0),
                                          labelText: "Email",
                                          filled: true,
                                          fillColor: Colors.blue.shade50,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 22,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        validator: (value) {
                                          if (value!.length < 7) {
                                            return 'Enter an 8 digit password';
                                          }
                                          return null;
                                        },
                                        controller: _pwdControllerPhone,
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.password,
                                            color: Colors.blue.shade900,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 40.0),
                                          labelText: "Password",
                                          filled: true,
                                          fillColor: Colors.blue.shade50,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 200,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Future.delayed(const Duration(seconds: 4), () async {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                              try {
                                                firebase_auth.UserCredential
                                                userCredential =
                                                await firebaseAuth
                                                    .signInWithEmailAndPassword(
                                                    email:
                                                    _emailControllerPhone
                                                        .text,
                                                    password:
                                                    _pwdControllerPhone
                                                        .text);
                                                print(userCredential
                                                    .user!.displayName);
                                                if (_emailControllerPhone.text ==
                                                    "mbuguangigi254@gmail.com") {
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                      '/adminHome',
                                                          (route) => true);
                                                } else {
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                      '/Verify',
                                                          (route) => true);
                                                }
                                              } catch (e) {
                                                final snackbar = SnackBar(
                                                    content:
                                                    Text(e.toString()));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackbar);
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }

                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue.shade900,
                                          ),
                                          child: isLoading == true
                                              ? CircularProgressIndicator()
                                              : Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 250.0),
                child: Row(
                  children: [
                    Container(
                      width: 400,
                      height: 542,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset('assets/white.png'),
                          ))
                        ],
                      ),
                    ),
                    Container(
                        width: 550,
                        height: 542,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.0),
                                child: Container(
                                  height: 2.0,
                                  width: 115.0,
                                  color: Colors.blue,
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(70.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: (email) => email != null &&
                                                !EmailValidator.validate(email)
                                            ? 'Enter a valid email'
                                            : null,
                                        controller: _emailController,
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.blue.shade900,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 40.0),
                                          labelText: "Email",
                                          filled: true,
                                          fillColor: Colors.indigo.shade50,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        validator: (value) {
                                          if (value!.length < 7) {
                                            return 'Enter an 8 digit password';
                                          }
                                          return null;
                                        },
                                        controller: _pwdController,
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.password,
                                            color: Colors.blue.shade900,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 40.0),
                                          labelText: "Password",
                                          filled: true,
                                          fillColor: Colors.indigo.shade50,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FlutterSocialButton(
                                        onTap: () {
                                          print("Login with Google");
                                        },
                                        buttonType: ButtonType.google,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 200,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Future.delayed(const Duration(seconds: 4), () async {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                              try {
                                                firebase_auth.UserCredential
                                                    userCredential =
                                                    await firebaseAuth
                                                        .signInWithEmailAndPassword(
                                                            email:
                                                                _emailController
                                                                    .text,
                                                            password:
                                                                _pwdController
                                                                    .text);
                                                print(userCredential
                                                    .user!.displayName);
                                                if (_emailController.text ==
                                                    "mbuguangigi254@gmail.com") {
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/adminHome',
                                                          (route) => true);
                                                } else {
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/userhome',
                                                          (route) => true);
                                                }
                                              } catch (e) {
                                                final snackbar = SnackBar(
                                                    content:
                                                        Text(e.toString()));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackbar);
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.blue.shade900,
                                          ),
                                          child: isLoading == true
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
