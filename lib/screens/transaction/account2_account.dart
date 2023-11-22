import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/models/superbase.dart';
import 'package:intl/intl.dart';
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
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Insert your password"),
                              content: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter A Valid password';
                                  }
                                  return null;
                                },
                                controller: password,
                                cursorColor: Colors.black,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: Colors.blue.shade900,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  labelText: "Password",
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
                                        AuthCredential credential = EmailAuthProvider.credential(
                                          email:email.toString(),
                                          password: password.text,
                                        );

                                        await user.reauthenticateWithCredential(credential).catchError((error){
                                          Alert(
                                              context: context,
                                              type: AlertType.error,
                                              title: "Password",
                                              desc: "$error",
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "Close",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () => Navigator.pop(context),
                                                  width: 120,
                                                )
                                              ]

                                          ).show();
                                        });
                                        try {
                                          print("TRANSFER STARTED");
                                          String transactionID = generateTransactionID(10);
                                          DocumentReference senderReference = FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_uid);
                                          DocumentReference receiverReference = FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(senderUID);
                                          DocumentReference bankTransaction = FirebaseFirestore.instance
                                              .collection('acc2acc Transactions')
                                              .doc(transactionID);
                                          CollectionReference mailCollection = FirebaseFirestore.instance.collection("mail");
                                          // Reauthenticate the user
                                          FirebaseFirestore.instance.runTransaction((transaction) async {
                                            final senderSnapshot = await transaction.get(senderReference);
                                            final receiverSnapshot = await transaction.get(receiverReference);
                                            if(senderSnapshot.get('amount') > double.parse(amount.text) -1){
                                              Timestamp timestamp = Timestamp.now();
                                              DateTime dateTime = timestamp.toDate();

                                              String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);


                                              double amountT = double.tryParse(amount.text) ?? 0.0;

                                              double newSenderAmount = senderSnapshot.get("amount") - amountT;
                                              double newReceiverAmount = receiverSnapshot.get("amount") + amountT;

                                              transaction.update(senderReference, {'amount': newSenderAmount});

                                              transaction.set(
                                                senderReference.collection("transaction").doc(transactionID),
                                                {
                                                  'amount': amountT,
                                                  'createdAt': formattedDate.toString(),
                                                  'status': "sent",
                                                  'id': transactionID,
                                                  "senderReceiver": _emailControllerPhone.text
                                                },
                                              );

                                              transaction.update(receiverReference, {'amount': newReceiverAmount});

                                              // Add a transaction entry for the receiver
                                              transaction.set(
                                                receiverReference.collection("transaction").doc(transactionID),
                                                {
                                                  'amount': amountT,
                                                  'createdAt': formattedDate.toString(),
                                                  'status': "received",
                                                  'senderReceiver':'${widget.account}',
                                                  'id': transactionID,
                                                },
                                              );
                                              //document bank transaction

                                              transaction.set(
                                                bankTransaction,
                                                {
                                                  'amount': amountT,
                                                  'createdAt': formattedDate.toString(),
                                                  'status': "received",
                                                  'sender':'${widget.account}',
                                                  'Receiver':_emailControllerPhone.text,
                                                  'id': transactionID,
                                                },
                                              );

                                              await mailCollection.add({
                                                'to': email,
                                                'message': {
                                                  'subject': 'Bank Transfer',
                                                  'html': 'dear ${widget.name}, \n You have succesfully sent $amountT to $name at ${formattedDate.toString()}. Reference number $transactionID',
                                                },
                                              });

                                              await mailCollection.add({
                                                'to': userDoc['email'],
                                                'message': {
                                                  'subject': 'Bank Transfer',
                                                  'html': 'dear $name, \n You have succesfully reveived $amountT from ${widget.name} at ${formattedDate.toString()}. Reference number $transactionID',
                                                },
                                              }).then((value) {
                                                Navigator.pop(context);

                                                Alert(
                                                  context: context,
                                                  type: AlertType.success,
                                                  title: "Transaction",
                                                  desc: "Transaction of ${amount.text} to $name is successfull",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "OKAY",
                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                      ),
                                                      onPressed: () => Navigator.pop(context),
                                                      width: 120,
                                                    )
                                                  ],

                                                ).show();
                                              });
                                            } else{
                                              return Alert(
                                                  context: context,
                                                  type: AlertType.error,
                                                  title: "Funds",
                                                  desc: "Insufficient Funds",
                                                  buttons: [
                                                    DialogButton(
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                      ),
                                                      onPressed: () => Navigator.pop(context),
                                                      width: 120,
                                                    )
                                                  ]

                                              ).show();
                                            }

                                          }).then((value) {
                                            Navigator.pop(context);
                                            amount.clear();
                                            _emailControllerPhone.clear();
                                            password.clear();
                                          });
                                        } catch (e) {
                                          print(e);
                                          Navigator.pop(context);
                                          Alert(
                                            context: context,
                                            type: AlertType.error,
                                            title: "Transaction",
                                            desc: "Transaction not successfull",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                onPressed: () => Navigator.pop(context),
                                                width: 120,
                                              )
                                            ]

                                          ).show();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade900,
                                      ),
                                      child: Text("Send")),
                                )
                              ],
                            ));
                  },
                  child: Text("send"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                ),
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


}
