/*
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../main.dart';

class Account2Account extends StatefulWidget {
  String uid;
  String name;
  String account;
  String phoneNumber;


  Account2Account(
      {Key? key,
      required this.name,
      required this.account,
      required this.phoneNumber,
      required this.uid
      })
      : super(key: key);

  @override
  _Account2AccountState createState() => _Account2AccountState();
}

class _Account2AccountState extends State<Account2Account> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailControllerPhone = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Send to Another Acc",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Enter A Valid account';
                  }
                  return null;
                },
                controller: _emailControllerPhone,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue.shade900,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                  labelText: "Account",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter the G-Dairies Account number of the recipient",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 380,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            OpenDialog();
                          }
                        },
                        child: Text("Send"))),
              )
            ],
          ),
        ),
      ),
    );
  }

  OpenDialog() {
    FirebaseFirestore.instance
        .collection('users')
        .where('account', isEqualTo: _emailControllerPhone.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one user with the given name, retrieve the age.
        var userDoc = querySnapshot.docs.first;
        var name = userDoc['name'];
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Account: $name"),
            content: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter A Valid Amount';
                }
                return null;
              },
              controller: amount,
              cursorColor: Colors.black,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.blue.shade900,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                labelText: "Amount",
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: ElevatedButton(
                    onPressed: () async {
                      final User? user = auth.currentUser;
                      final _uid = user!.uid;
                      final email = user!.email;
                      var senderUID = userDoc['id'];
                      final intNum = int.parse(userDoc['phone_number']);
                      try {
                        print("TRANSFER STARTED");
                        DocumentReference senderReference = FirebaseFirestore.instance
                            .collection('users')
                            .doc(_uid);
                        DocumentReference receiverReference = FirebaseFirestore.instance
                            .collection('users')
                            .doc(senderUID);
                        // Reauthenticate the user
                        print("TRANSFer officialy started");
                        double amountT = double.tryParse(amount.text) ?? 0.0;
                        // Initialize a WriteBatch
                        WriteBatch batch = FirebaseFirestore.instance.batch();
                        print("batch writing");

                        double newSenderAmount = 0.0;
                        double newReceiverAmount = 0.0;
                        String transactionID = generateTransactionID(10);
                        print("generated id");
                        print(transactionID);

                        batch.update(senderReference, {'amount': FieldValue.increment(-amountT)});
                        batch.set(
                          senderReference.collection("transaction").doc(generateTransactionID(intNum)),
                          {
                            'amount': amountT,
                            'createdAt': FieldValue.serverTimestamp(),
                            'status': "sent",
                            'id': transactionID,
                            "senderReceiver": _emailControllerPhone.text
                          },
                        );
                        print("user details written");

                        batch.update(receiverReference, {'amount': FieldValue.increment(amountT)});
                        batch.set(
                          receiverReference.collection("transaction").doc(generateTransactionID(intNum)),
                          {
                            'amount': amountT,
                            'createdAt': FieldValue.serverTimestamp(),
                            'status': "received",
                            'senderReceiver':'${widget.account}',
                            'id': transactionID,
                          },
                        );

                        await batch.commit();
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Transaction",
                          desc: "Transaction of ${amount.text} to $name is successfull",

                        ).show();
                      } catch (e) {
                        print(e);
                        Navigator.pop(context);
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Transaction",
                          desc: "Transaction not successfull",

                        ).show();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: Text("Send")),
              ),
            ],
          ),
        );
      } else {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("No user by the account"),
                ));
      }
    }).catchError((error) {
      print('Error retrieving user data: $error');
    });
  }

  String generateTransactionID(int length) {
    String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String string = '';
    for (int i = 0; i < length; i++) {
      string += chars[Random().nextInt(chars.length)];
    }
    return string;
  }
}

* */