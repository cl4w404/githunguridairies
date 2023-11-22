import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/main.dart';
import 'package:g_dairies/models/superbase.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Savings extends StatefulWidget {
  Savings({Key? key}) : super(key: key);

  @override
  _SavingsState createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {
  TextEditingController amount = TextEditingController();
  TextEditingController purpose = TextEditingController();
  TextEditingController target = TextEditingController();
  var _currentSelectedValue;
  var _currencies = [
    "1 Months",
    "3 Months",
    "6 Months",
    "12 Months",
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = Timestamp.now();
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Add Savings Goal",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter A Valid target';
                  }
                  return null;
                },
                controller: target,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.blue.shade900,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                  labelText: "Target",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter A Valid role';
                  }
                  return null;
                },
                controller: amount,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.blue.shade900,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                  labelText: "Starting Amount",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter A Valid role';
                  }
                  return null;
                },
                controller: purpose,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.blue.shade900,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                  labelText: "Purpose",
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Tap to select savings plan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              SizedBox(
                height: 10,
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: "Insert duration",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    isEmpty: _currentSelectedValue ==
                        Text(
                          "Select Repayment duration",
                          style: TextStyle(color: Colors.black),
                        ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedValue,
                        isDense: true,
                        onChanged: (value) {
                          setState(() {
                            _currentSelectedValue = value;
                            state.didChange(value);
                          });
                        },
                        items: _currencies.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 183,
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final User? user = auth.currentUser;
                            final _uid = user!.uid;
                            final timestamp = DateTime.now();

                            String transactionID = generateTransactionID(10);
                            final CollectionReference _usersCollection =
                                FirebaseFirestore.instance.collection('users');
                            QuerySnapshot snapshot = await _usersCollection
                                .where('id', isEqualTo: '$_uid')
                                .get();
                            if (snapshot.docs.isNotEmpty) {
                              double fieldValue =
                                  snapshot.docs.first.get('amount');
                              if (fieldValue > double.parse(amount.text)) {
                                double amounT =
                                    fieldValue - double.parse(amount.text);
                                _usersCollection
                                    .doc(_uid)
                                    .update({'amount': amounT});
                                _usersCollection
                                    .doc(_uid)
                                    .collection('transaction')
                                    .doc(transactionID)
                                    .set({
                                  'amount': double.parse(amount.text),
                                  'createdAt': formattedDate.toString(),
                                  'status': "sendS",
                                  'senderReceiver': 'self',
                                  'id': transactionID,
                                });
                              } else {
                                Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Funds",
                                    desc: "Insufficient Funds",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Close",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ]).show();
                              }
                            } else {
                              print('No user found with the provided username');
                            }

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(_uid)
                                .collection('savings')
                                .doc("${purpose.text}")
                                .set({
                              'amount': double.parse(amount.text),
                              'purpose': purpose.text,
                              "plan": _currentSelectedValue,
                              "target": double.parse(target.text),
                              'date': DateTime.now(),
                            }).then((value) {
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Goal",
                                desc: "Goal Created Successfully",
                                buttons: [],
                              ).show();
                              amount.clear();
                              purpose.clear();
                              target.clear();
                            }).onError((error, stackTrace) {
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Error",
                                desc: "$error",
                                buttons: [],
                              ).show();
                            });
                          }
                        },
                        child: Text("Enter"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
