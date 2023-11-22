import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/main.dart';
import 'package:g_dairies/screens/transaction/acc2_mpesa.dart';
import 'package:g_dairies/screens/transaction/account2_account.dart';
import 'package:g_dairies/screens/transaction/mpesa2_acc.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final name = user!.displayName;
    final email = user!.email;
    final photo = user!.photoURL;

    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['passport']),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Text(data['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child: Container(
                            height: 2.0,
                            width: 115.0,
                            color: Colors.blue.shade50,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 180,
                    width: 360,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        image: DecorationImage(
                          image: AssetImage('assets/card.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            trailing: SizedBox(
                                width: 100,
                                height: 50,
                                child: Image.asset('assets/white.png')),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          ListTile(
                            leading: Image.asset('assets/chip.png'),
                            title: Text(
                              "${data['account']}",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${data['name']}",
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Image.asset('assets/visa.png'),
                          )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Account2Account(
                                        name: "${data['name']}",
                                        account: "${data['account']}",
                                        phoneNumber: "${data['account']}",
                                        uid: "${data['account']}",
                                      )));
                              print("Money Transfered");
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/transfaer.png'),
                            ),
                          ),
                          Text("G-Dairie Acc",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Mpesa2Acc(
                                        name: "${data['name']}",
                                        account: "${data['account']}",
                                        phoneNumber: "${data['phone_number']}",
                                        amount: "${data['amount']}",
                                        uid: "${data['id']}",
                                      )));
                              print("Money deposited");
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/deposit.png'),
                            ),
                          ),
                          Text(
                            "Deposit",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Acc2Mpesa(
                                        name: "${data['name']}",
                                        account: "${data['account']}",
                                        phoneNumber: "${data['phone_number']}",
                                        amount: "${data['amount']}",
                                        uid: "${data['id']}",
                                      )));
                              print("Money withdrawn");
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/withdraw.png'),
                            ),
                          ),
                          Text("Withdraw",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Latest Transactions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: users
                        .doc(uid)
                        .collection('transaction')
                        .orderBy('createdAt', descending: true)
                        .limit(3)
                        .snapshots(),
                    builder: (context, snapsho) {
                      if (snapsho.hasData) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapsho.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data7 = snapsho.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                String amount = data7['amount'].toString();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ListTile(
                                    style: ListTileStyle.list,
                                    tileColor: Colors.blue.shade50,
                                    leading: (data7['status'] == "withdraw" ||
                                            data7['status'] == "sent" ||
                                            data7['status'] == "sendS")
                                        ? CircleAvatar(
                                            backgroundColor: Colors.redAccent,
                                            child: Text(
                                              "CR",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                        : CircleAvatar(
                                            backgroundColor: Colors.greenAccent,
                                            child: Text("DR",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                    title: (data7['status'] == "withdraw" ||
                                            data7['status'] == "sent" ||
                                            data7['status'] == "sendS")
                                        ? Text(
                                            data7['id'],
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text(
                                            data7['id'],
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                    trailing: Text("$amount Ksh"),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        );
                      }
                    })
              ],
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RiveAnimation.asset('assets/dot.rive'),
          ],
        );
      },
    ));
  }
}
