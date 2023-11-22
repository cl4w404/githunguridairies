import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mpesa/dart_mpesa.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/screens/transaction/keys.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Acc2Mpesa extends StatefulWidget {
  var phoneNumber;
  var amount;
  var name;
  var account;
  var uid;

  Acc2Mpesa(
      {Key? key,
      required this.name,
      required this.account,
      required  this.phoneNumber,
      required this.amount,
      required this.uid})
      : super(key: key);

  @override
  _Acc2MpesaState createState() => _Acc2MpesaState();
}

class _Acc2MpesaState extends State<Acc2Mpesa> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Withdraw",
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
                "Enter The amount you would like to Withdraw. Note that the amount should be 1 Ksh and above",
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            DocumentReference senderReference = FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.uid);
                           if(double.parse(widget.amount) > double.parse(amount.text) -1){
                             var mpesa = Mpesa(
                                 shortCode: '600989',
                                 consumerKey: kConsumerKey,
                                 consumerSecret: kConsumerSecret,
                                 initiatorName: widget.name,
                                 securityCredential:securityCredentials,
                                 passKey:
                                 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919',
                                 identifierType:
                                 IdentifierType.OrganizationShortCode,
                                 // Type of organization, options, OrganizationShortCode, TillNumber, OrganizationShortCode
                                 applicationMode: ApplicationMode.test);

                             var _res = await mpesa.b2cTransaction(
                                 phoneNumber: widget.phoneNumber,
                                 amount: double.parse(amount.text),
                                 remarks: widget.account,
                                 occassion: 'null',
                                 resultURL: 'https://us-central1-sem3-e5826.cloudfunctions.net/acc2Mpesa',
                                 queueTimeOutURL:
                                 'https://mydomain.com/b2c/queue',
                                 commandID: BcCommandId.BusinessPayment // default
                             );

                             print(_res.statusCode);
                             print(_res.rawResponse);
                           } else{
                               Alert(
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
