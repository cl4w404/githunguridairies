import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:g_dairies/main.dart';
import 'package:rive/rive.dart';

class Mpesa2Acc extends StatefulWidget {
  String name;
  var account;
  String phoneNumber;
  String amount;
  String uid;

  Mpesa2Acc(
      {Key? key,
      required this.name,
      required this.account,
      required this.phoneNumber,
      required this.amount,
      required this.uid})
      : super(key: key);

  @override
  _Mpesa2AccState createState() => _Mpesa2AccState();
}

class _Mpesa2AccState extends State<Mpesa2Acc> {
  TextEditingController amount = TextEditingController();
  late DocumentReference paymentsRef;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _initialized = false;
  bool _error = false;
  bool isLoading = false;

  Future<void> updateAccount(String mCheckoutRequestID) {
    Map<String, String> initData = {
      'CheckoutRequestID': mCheckoutRequestID,
    };

    paymentsRef.set({"info": "$widget.uid receipts data goes here."});

    return paymentsRef
        .collection("transaction")
        .doc(mCheckoutRequestID)
        .set(initData)
        .then((value) => print("Transaction Initialized."))
        .catchError((error) => print("Failed to init transaction: $error"));
  }

  Stream<DocumentSnapshot>? getAccountBalance() {
    if (_initialized) {
      return paymentsRef.snapshots();
    } else {
      return null;
    }
  }

  // mpesa function

  Future<void> startCheckout(

      {required String userPhone, required double amount}) async {
    //Preferably expect 'dynamic', response type varies a lot!
    setState(() {
      isLoading = true;
    });
    dynamic transactionInitialisation;
    //Better wrap in a try-catch for lots of reasons.
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: userPhone,
          partyB: "174379",
          callBackURL: Uri(
              scheme: "https",
              host: "us-central1-sem3-e5826.cloudfunctions.net",
              path: "/mpesaStkUrl"),
          accountReference: widget.account.toString(),
          phoneNumber: userPhone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "purchase",
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      print("TRANSACTION RESULT: " + transactionInitialisation.toString());
      /*Update your db with the init data received from initialization response,
      * Remaining bit will be se  nt via callback url*/
      return transactionInitialisation;
    } catch (e) {
      //For now, console might be useful
      print("CAUGHT EXCEPTION: " + e.toString());

      /*
      Other 'throws':
      1. Amount being less than 1.0
      2. Consumer Secret/Key not set
      3. Phone number is less than 9 characters
      4. Phone number not in international format(should start with 254 for KE)
       */
    }
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });

      paymentsRef =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);
    } catch (e) {
      print(e.toString());
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  // end of mpesa function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Deposit",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: isLoading == true
          ? Column(
              children: [RiveAnimation.asset('assets/waiting.riv')],
            )
          : Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter A Valid amount';
                        }
                        return null;
                      },
                      controller: amount,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.monetization_on,
                          color: Colors.blue.shade900,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 40.0),
                        labelText: "Amount",
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
                      "Enter The amount you would like to Deposit. Note that the amount should be 1 Ksh and above",
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


                                double Amount = double.parse(amount.text);
                                if (_error) {
                                  print("Error initializing Fb");
                                  return;
                                }

                                // Show a loader until FlutterFire is initialized
                                if (!_initialized) {
                                  print("Fb Not initialized");
                                  return;
                                }

                                startCheckout(
                                    userPhone: widget.phoneNumber,
                                    amount: Amount);
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: Text("Send"))),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
