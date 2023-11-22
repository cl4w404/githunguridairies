import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_tabbar_widget/rounded_tabbar_widget.dart';

class Transactions extends StatefulWidget {
  Transactions({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return RoundedTabbarWidget(
      itemNormalColor: Colors.lightBlue[300],
      itemSelectedColor: Colors.lightBlue[900],
      tabBarBackgroundColor: Colors.lightBlue[100],
      tabIcons: [
        Icons.home,
        Icons.favorite,
      ],
      pages: [
        MpesTransaction(),
        Acount2Account(),
      ],
      selectedIndex: 0,
      onTabItemIndexChanged: (int index) {
        print('Index: $index');
      },
    );
  }
}

class MpesTransaction extends StatefulWidget {
  const MpesTransaction({super.key});

  @override
  State<MpesTransaction> createState() => _MpesTransactionState();
}

class _MpesTransactionState extends State<MpesTransaction> {
  List<DataRow> client = [];
  String name ="";

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Mpesa transactions",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 475,
          child: TextFormField(
            onChanged: (val){
              setState(() {
                name=val;
              });
            },
            //controller: password,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.numbers,
                color: Colors.blue.shade900,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
              labelText: "Enter ID",
              filled: true,
              fillColor: Colors.indigo.shade50,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('transaction')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final clients = snapshot.data!.docs.reversed.toList();
                for (var document in clients) {
                  final clientData = DataRow(cells: [
                    DataCell(
                      Text(
                        "${document['senderReceiver']}",
                      ),
                    ),
                    DataCell(
                      Text(document['id']),
                    ),
                    DataCell(Text("${document['amount'].toString()}")),
                    DataCell(
                      Text(document['createdAt']),
                    ),
                    DataCell(
                      Text(document['phone'].toString()),
                    ),
                    DataCell(
                      Text(document['status']),
                    ),
                  ]);
                  client.add(clientData);
                }
              }
              return DataTable(columns: [
                DataColumn(
                    label: Text('Initiator',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Id',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Amount',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Date',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Phone',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Status',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ], rows: client);
            }),
      ],
    ));
    ;
  }
}

class Acount2Account extends StatefulWidget {
  const Acount2Account({super.key});

  @override
  State<Acount2Account> createState() => _Acount2AccountState();
}

class _Acount2AccountState extends State<Acount2Account> {
  List<DataRow> client = [];
  String name ="";
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Account 2 account Transactions",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 475,
          child: TextFormField(
            onChanged: (val){
              setState(() {
                name=val;
              });
            },
            //controller: password,
            cursorColor: Colors.black,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.numbers,
                color: Colors.blue.shade900,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
              labelText: "Insert ID",
              filled: true,
              fillColor: Colors.indigo.shade50,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('acc2acc Transactions')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final clients = snapshot.data!.docs.reversed.toList();
                for (var document in clients) {
                  final clientData = DataRow(cells: [
                    DataCell(
                      Text(document['id']),
                    ),
                    DataCell(Text("${document['amount'].toString()}")),
                    DataCell(
                      Text(document['createdAt'].toString()),
                    ),
                    DataCell(
                      Text(document['sender']),
                    ),
                    DataCell(
                      Text(document['Receiver']),
                    ),
                  ]);
                  client.add(clientData);
                }
              }
              return DataTable(columns: [
                DataColumn(
                    label: Text('Id',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Amount',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Date',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Sender',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('reveiver',
                        style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ], rows: client);
            }),
      ],
    ));
  }
}
