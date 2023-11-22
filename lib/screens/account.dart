import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:g_dairies/main.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Account extends StatefulWidget {
  Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc(uid).get(),
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
                    return Column(
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
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
                          height: 20,
                        ),
                        Container(
                          color: Colors.blue.shade50,
                          height: 150,
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_balance_wallet_outlined,
                                  color: Colors.blue.shade900),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "${data['amount'].toString()}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              Text("Ksh"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                            leading: Icon(Icons.book),
                            title: Text("Request for Transaction history"),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Transaction history"),
                                        content: Text(
                                            "Ksh 100 will be dedacted from your Account"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                final directory =
                                                    await getExternalStorageDirectory();
                                                List<Map<String, dynamic>>
                                                    customerData =
                                                    await getCustomerData();

                                                final PdfDocument document =
                                                    PdfDocument();
                                                final PdfPage page =
                                                    document.pages.add();
                                                final PdfGrid grid = PdfGrid();
                                                grid.columns.add(count: 6);

                                                final PdfGridRow headerRow =
                                                    grid.headers.add(1)[0];
                                                headerRow.cells[0].value =
                                                    'Initiator';
                                                headerRow.cells[1].value = 'Id';
                                                headerRow.cells[2].value =
                                                    'Amount';
                                                headerRow.cells[3].value =
                                                    'Date';
                                                headerRow.cells[4].value =
                                                    'Debit';
                                                headerRow.cells[5].value =
                                                    'Credit';

                                                headerRow.style.font =
                                                    PdfStandardFont(
                                                        PdfFontFamily.helvetica,
                                                        10,
                                                        style:
                                                            PdfFontStyle.bold);

                                                for (int i = 0;
                                                    i < customerData.length;
                                                    i++) {
                                                  final PdfGridRow row =
                                                      grid.rows.add();
                                                  row.cells[0]
                                                      .value = (customerData[i]
                                                              ['status'] ==
                                                          "sent")
                                                      ? "Self"
                                                      : "${customerData[i]['senderReceiver']}";
                                                  row.cells[1].value =
                                                      customerData[i]['id']
                                                              .toString()
                                                              .isNotEmpty
                                                          ? customerData[i]
                                                              ['id']
                                                          : "";
                                                  row.cells[2].value =
                                                      "${customerData[i]['amount'].toString()}";
                                                  row.cells[4]
                                                      .value = (customerData[i]
                                                                  ['status'] ==
                                                              "deposit" ||
                                                          customerData[i]
                                                                  ['status'] ==
                                                              "received" ||
                                                          customerData[i]
                                                                  ['status'] ==
                                                              "receiverS")
                                                      ? "Debit"
                                                      : "";
                                                  row.cells[5]
                                                      .value = (customerData[i]
                                                                  ['status'] ==
                                                              "withdraw" ||
                                                          customerData[i]
                                                                  ['status'] ==
                                                              "sent" ||
                                                          customerData[i]
                                                                  ['status'] ==
                                                              "sendS")
                                                      ? "Credit"
                                                      : "";
                                                }
                                                grid.style.cellPadding =
                                                    PdfPaddings(
                                                        left: 5, top: 5);
                                                grid.draw(
                                                    page: page,
                                                    bounds: Rect.fromLTWH(
                                                        0,
                                                        0,
                                                        page
                                                            .getClientSize()
                                                            .width,
                                                        page
                                                            .getClientSize()
                                                            .height));
                                                print(directory!.path);
                                                File('${directory!.path}/Gstatement.pdf')
                                                    .writeAsBytes(
                                                        await document.save());
                                                // Dispose the document.
                                                document.dispose();
                                              },
                                              child: Text("Continue")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      ));
                            }),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text("Contact us"),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [],
                  );
                })
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getCustomerData() async {
    // Retrieve data from Firestore.
    final User? user = auth.currentUser;
    final _uid = user!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('transaction')
        .get();

    // Store the data in a List.
    List<Map<String, dynamic>> customerData = querySnapshot.docs
        .map((QueryDocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return customerData;
  }
}
