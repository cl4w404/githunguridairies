import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/main.dart';
import 'package:g_dairies/models/superbase.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SavingPersonal extends StatefulWidget {
  String purpose;
  var amount;
  String plan;
  var target;
  var maturity;

  SavingPersonal(
      {Key? key,
      required this.purpose,
      required this.amount,
      required this.plan,
      required this.target,
      required this.maturity})
      : super(key: key);

  @override
  _SavingPersonalState createState() => _SavingPersonalState();
}

class _SavingPersonalState extends State<SavingPersonal> {
  TextEditingController ksh = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.maturity);
    final timestamp = widget.maturity;
    final dateTime = timestamp.toDate();
    Duration threeMonths = Duration(days: 30 * 3);
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    DateTime newDate = dateTime.add(threeMonths);
    final formattedDateT = newDate.toString();
    print(formattedDate);
    final User? user = auth.currentUser;
    final _uid = user!.uid;
    final email = user!.email;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "${widget.purpose} Goals details",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Deposit"),
                                content: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter A Valid Amount';
                                    }
                                    return null;
                                  },
                                  controller: ksh,
                                  cursorColor: Colors.black,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.blue.shade900,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 40.0),
                                    labelText: "Amount",
                                    filled: true,
                                    fillColor: Colors.blue.shade50,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        final CollectionReference
                                            _usersCollection = FirebaseFirestore
                                                .instance
                                                .collection('users');
                                        QuerySnapshot snapshot =
                                            await _usersCollection
                                                .where('id', isEqualTo: '$_uid')
                                                .get();
                                        double fieldValue =
                                            snapshot.docs.first.get('amount');
                                        double amounT = double.parse(
                                                fieldValue.toString()) -
                                            double.parse(ksh.text);
                                        _usersCollection
                                            .doc(_uid)
                                            .update({'amount': amounT});
                                        String transactionID =
                                            generateTransactionID(10);
                                        _usersCollection
                                            .doc(_uid)
                                            .collection('transaction')
                                            .doc(transactionID)
                                            .set({
                                          'amount': double.parse(ksh.text),
                                          'createdAt': formattedDate.toString(),
                                          'status': "sendS",
                                          'senderReceiver': 'self',
                                          'id': transactionID,
                                        });
                                        QuerySnapshot snapshots =
                                            await _usersCollection
                                                .doc(_uid)
                                                .collection('savings')
                                                .where('purpose',
                                                    isEqualTo: widget.purpose)
                                                .get();
                                        int fieldValue2 =
                                            snapshots.docs.first.get('amount');
                                        double amounT2 = double.parse(
                                                fieldValue2.toString()) +
                                            double.parse(ksh.text);
                                        _usersCollection
                                            .doc(_uid)
                                            .collection('savings')
                                            .doc(widget.purpose)
                                            .update(
                                          {'amount': amounT2},
                                        ).then((value) async {
                                          CollectionReference mailCollection =
                                              FirebaseFirestore.instance
                                                  .collection("mail");
                                          await mailCollection.add({
                                            'to': email,
                                            'message': {
                                              'subject': 'Deposit',
                                              'html':
                                                  ' You have succesfully deposited ${ksh.text} to ${widget.purpose} savings account at ${formattedDate.toString()}. ref: $transactionID',
                                            },
                                          });
                                          Alert(
                                            context: context,
                                            type: AlertType.success,
                                            title: "deposit",
                                            desc:
                                                "Your deposit of ${ksh.text} from ${widget.purpose} goal is successful",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "OKAY",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                width: 120,
                                              )
                                            ],
                                          ).show();
                                        });
                                        ksh.clear();
                                      },
                                      child: Text("Deposit"))
                                ],
                              ));
                    },
                    child: Row(
                      children: [Text("Deposit to goal"), Icon(Icons.add)],
                    )),
                SizedBox(
                  width: 22,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () async {
                      final User? user = auth.currentUser;
                      final _uid = user!.uid;
                      final CollectionReference _usersCollection =
                          FirebaseFirestore.instance.collection('users');
                      QuerySnapshot snapshot = await _usersCollection
                          .where('id', isEqualTo: '$_uid')
                          .get();
                      var fieldValue = snapshot.docs.first.get('amount');
                      double amounT =
                          double.parse(fieldValue.toString()) + double.parse(widget.amount.toString());
                      String transactionID = generateTransactionID(10);
                      _usersCollection
                          .doc(_uid)
                          .collection('transaction')
                          .doc(transactionID)
                          .set({
                        'amount': double.parse(widget.amount.toString()),
                        'createdAt': formattedDate.toString(),
                        'status': "receiverS",
                        'senderReceiver': 'self',
                        'id': transactionID,
                      });
                      _usersCollection.doc(_uid).update({'amount': amounT});
                      QuerySnapshot snapshots = await _usersCollection
                          .doc(_uid)
                          .collection('savings')
                          .where('purpose', isEqualTo: widget.purpose)
                          .get();
                      _usersCollection
                          .doc(_uid)
                          .collection('savings')
                          .doc(widget.purpose)
                          .update({'amount': 0}).then((value) async {
                        Alert(
                          context: context,
                          type: AlertType.success,
                          title: "Withdrawal",
                          desc:
                              "Your withdrawal of ${ksh.text} from ${widget.purpose} goal is successful",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OKAY",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                        CollectionReference mailCollection =
                            FirebaseFirestore.instance.collection("mail");
                        await mailCollection.add({
                          'to': email,
                          'message': {
                            'subject': 'Withdrawal',
                            'html':
                                ' You have succesfully withdrawn ${widget.amount} from ${widget.purpose} savings account at ${formattedDate.toString()}. ref $transactionID)',
                          },
                        });
                      });
                      ksh.clear();
                    },
                    child: Row(
                      children: [Text("Withdraw goal"), Icon(Icons.remove)],
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              tileColor: Colors.blue.shade50,
              leading: Container(
                  height: 50,
                  width: 70,
                  child: Center(child: Text('Purpose:'))),
              title: Text(
                widget.purpose,
                style: TextStyle(color: Colors.green),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                tileColor: Colors.blue.shade50,
                leading: Container(
                    height: 50,
                    width: 70,
                    child: Center(child: Text('Target:'))),
                title: Text(
                  "${widget.target} Ksh",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                tileColor: Colors.blue.shade50,
                leading: Container(
                    height: 50,
                    width: 70,
                    child: Center(child: Text('Date initiated:'))),
                title: Text(
                  "${formattedDate}",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                tileColor: Colors.blue.shade50,
                leading: Container(
                    height: 50,
                    width: 70,
                    child: Center(child: Text('Amount'))),
                title: Text(
                  "${widget.amount}",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                tileColor: Colors.blue.shade50,
                leading: Container(
                    height: 50,
                    width: 70,
                    child: Center(child: Text('Date of matuiry'))),
                title: Text(
                  "$formattedDateT",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
