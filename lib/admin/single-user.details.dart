import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/admin/admin_index.dart';
import 'package:g_dairies/main.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

class SingleUserDetails extends StatefulWidget {
  String uid;

  SingleUserDetails({Key? key, required this.uid}) : super(key: key);

  @override
  State<SingleUserDetails> createState() => _SingleUserDetailsState();
}

class _SingleUserDetailsState extends State<SingleUserDetails> {
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  Future<void> resetPassword(
    String email,
  ) async {
    firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                  padding: const EdgeInsets.all(40.0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50.0), // You can adjust the radius as needed
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SidebarXExampleApp()));
                            },
                            child: Icon(
                              CupertinoIcons.arrow_left,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Account Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                        child: Container(
                          height: 1.0,
                          width: 700.0,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          radius: 55,
                          backgroundImage: NetworkImage(data['passport']),
                        ),
                        title: Text(
                          data['name'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['account'],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      CupertinoIcons.down_arrow,
                                      color: Colors.blue.shade900,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
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
                                        labelText: data['email'],
                                        filled: true,
                                        fillColor: Colors.indigo.shade50,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.blue.shade900,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                        labelText: data['phone_number'],
                                        filled: true,
                                        fillColor: Colors.indigo.shade50,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.perm_identity_rounded,
                                          color: Colors.blue.shade900,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                        labelText: data['national_id'],
                                        filled: true,
                                        fillColor: Colors.indigo.shade50,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 475,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Enter A Valid Password';
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 40.0),
                                        labelText: "Edit Password",
                                        filled: true,
                                        fillColor: Colors.indigo.shade50,
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 235,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        firebase_auth.FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: data['email'])
                                            .whenComplete(() {
                                          Alert(
                                            context: context,
                                            type: AlertType.success,
                                            title: "Activation Email",
                                            desc: "Activation email sent to ${data['email']}",
                                            buttons: [],
                                          ).show();
                                        });
                                      },
                                      child: Text("Edit password"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 235,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Edit Phone-Number"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade900,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Transactions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.uid)
                                  .collection('transaction')
                                  .snapshots(),
                              builder: (context, snapshots) {
                                List<DataRow> client =[];
                                 if (snapshots.connectionState ==
                                        ConnectionState.waiting)
                                    {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(80.0),
                                          child: RiveAnimation.asset(
                                              'assets/loading.riv'),
                                        ));
                                      }
                                 if (snapshots.hasData){
                                   final clients = snapshots.data!.docs.reversed.toList();

                                   for (var document in clients) {
                                     final clientData = DataRow(
                                         cells: [
                                           DataCell(
                                             Text(
                                               (document['status'] == "sent")
                                                   ? "Self"
                                                   : "${document['senderReceiver']}",
                                             ),
                                           ),
                                           DataCell(
                                             Text(
                                               document['id'].toString().isNotEmpty
                                                   ? document['id']
                                                   : "",
                                             ),
                                           ),
                                           DataCell(
                                              Text("${document['amount'].toString()}")
                                           ),
                                           DataCell(
                                             Text(
                                               document['createdAt'].toString().isNotEmpty
                                                   ? document['createdAt']
                                                   : "",
                                             ),
                                           ),
                                           DataCell(
                                             Text(
                                               (document['status'] == "deposit" || document['status'] == "received" || document['status'] == "receiverS")
                                                   ? "Debit"
                                                   : "",  style: TextStyle(color: Colors.green),
                                             ),
                                           ),
                                           DataCell(
                                             Text(
                                               (document['status'] == "withdraw" || document['status'] == "sent" || document['status'] == "sendS")
                                                   ? "Credit"
                                                   : "", style: TextStyle(color: Colors.red),
                                             ),
                                           ),

                                     ]);

                                     client.add(clientData);
                                   }
                                   //var data = snapshots.data!.docs[index].data() as Map<String, dynamic>;


                                 }
                                 return DataTable(
                                     columns: [

                                       DataColumn(
                                           label: Text(
                                           'Initiator',
                                           style: TextStyle(color: Colors.blue.shade900,fontSize: 18, fontWeight: FontWeight.bold)
                                       )),
                                       DataColumn(label: Text(
                                           'Id',
                                           style: TextStyle(color: Colors.blue.shade900,fontSize: 18, fontWeight: FontWeight.bold)
                                       )),
                                       DataColumn(label: Text(
                                           'Amount',
                                           style: TextStyle(color: Colors.blue.shade900,fontSize: 18, fontWeight: FontWeight.bold)
                                       )),
                                       DataColumn(label: Text(
                                           'Date',
                                           style: TextStyle(color: Colors.blue.shade900,fontSize: 18, fontWeight: FontWeight.bold)
                                       )),
                                       DataColumn(label: Text(
                                           'Debit',
                                           style: TextStyle(color: Colors.blue.shade900,fontSize: 18, fontWeight: FontWeight.bold)
                                       )),
                                       DataColumn(
                                           label: Text(
                                           'Credit',
                                           style: TextStyle(color: Colors.blue.shade900,fontSize: 18, fontWeight: FontWeight.bold)
                                       )),
                                     ],
                                     rows: client
                                 );;

                              }),
                        ),
                      ),
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
            }));
  }
}
