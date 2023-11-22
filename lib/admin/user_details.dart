import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/admin/single-user.details.dart';
import 'package:rive/rive.dart';

class UserDetails extends StatefulWidget {
  UserDetails({Key? key}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  TextEditingController secName = TextEditingController();
  String name = "";
  List searchResult = [];
  Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('users').snapshots();

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('account', isEqualTo: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;
    return screenSize < 800
        ? Container()
        : ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Search User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
               Padding(
                 padding: const EdgeInsets.only(top: 20.0, left: 300, right: 300),
                 child: SizedBox(
                   width: 700,
                   child: TextFormField(
                     onChanged: (value) {
                       searchFromFirebase(value);
                     },
                     validator: (value) {
                       if (value!.isEmpty) {
                         return 'Enter A Valid Name';
                       }
                       return null;
                     },
                     controller: secName,
                     cursorColor: Colors.black,
                     style: TextStyle(color: Colors.black),
                     decoration: InputDecoration(
                       prefixIcon: Icon(
                         Icons.person_2,
                         color: Colors.blue.shade900,
                       ),
                       contentPadding:
                           const EdgeInsets.symmetric(horizontal: 40.0),
                       labelText: "Enter Account number",
                       filled: true,
                       fillColor: Colors.indigo.shade50,
                       border: OutlineInputBorder(
                           borderSide:
                               BorderSide(color: Colors.blue.shade900),
                           borderRadius: BorderRadius.circular(50)),
                     ),
                   ),
                 ),
               ),

                       Container(
                         height: 700,
                         width: 700,
                         child: ListView.builder(
                           itemCount: searchResult.length,
                           itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.only(top:15.0, left: 20,right: 20),
                               child: ListTile(
                                 onTap: (){
                                   Navigator.of(context).push(MaterialPageRoute(
                                       builder: (context) => SingleUserDetails(
                                         uid: searchResult[index]['id'],

                                       )));
                                   print(searchResult[index]['id'],);
                                 },

                                 tileColor: Colors.white,
                                 splashColor:
                                 Colors.red.shade900,
                                 leading: CircleAvatar(
                                   backgroundImage:
                                   NetworkImage(
                                       searchResult[index]['passport']),
                                 ),
                                 title: Text(
                                   searchResult[index]['name'],
                                   style: TextStyle(
                                       fontSize: 19,
                                       fontWeight:
                                       FontWeight.bold),
                                 ),
                                 subtitle:
                                 Text(searchResult[index]['account']),
                                 trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade900,),
                               ),
                             );
                           },
                         ),
                       ),


            ],
          );
  }
}

const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
