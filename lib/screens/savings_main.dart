import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/main.dart';
import 'package:g_dairies/screens/saving_personal.dart';
import 'package:g_dairies/screens/savings.dart';
import 'package:rive/rive.dart';

class SavingsMain extends StatefulWidget {
  SavingsMain({Key? key}) : super(key: key);

  @override
  _SavingsMainState createState() => _SavingsMainState();
}

class _SavingsMainState extends State<SavingsMain> {
  firstLetter(String jina) {
    String firstLetter = jina[0];
    return firstLetter;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final _uid = user!.uid;
    final email = user!.email;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Savings",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_uid)
                  .collection('savings')
                  .snapshots(),
              builder: (context, snapshot) {
                List<ListTile> client = [];
                if (snapshot.hasData) {
                  final savings = snapshot.data!.docs.reversed.toList();
                  for (var document in savings) {
                    final save = ListTile(
                      tileColor: Colors.green.shade50,
                      splashColor: Colors.blue.shade900,
                      leading: Container(
                          height: 30,
                          width: 30,
                          color: Colors.green.shade900,
                          child: Center(
                              child: Text(
                            "${firstLetter(document['purpose'])}",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ))),
                      title: Text(document['purpose']),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.green.shade900,),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SavingPersonal(
                              purpose: "${document['purpose']}",
                              amount: "${document['amount']}",
                              plan: "${document['plan']}",
                              target: "${document['target']}",
                              maturity: document['date']
                            )));
                      },
                    );
                    client.add(save);
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: RiveAnimation.asset('assets/loading.riv'),
                  ));
                }
                return Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Savings()));
                        },
                        tileColor: Colors.blue.shade50,
                        leading: Container(
                            color: Colors.blue.shade900,
                            child: Icon(
                              CupertinoIcons.add,
                              color: Colors.white,
                            )),
                        title: Text("Add Savings Purpose"),
                      ),
                      Expanded(
                        child: ListView(
                          children: client,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    ));
  }
}
