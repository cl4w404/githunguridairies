import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rive/rive.dart';

class Loans extends StatefulWidget {
  Loans({Key? key}) : super(key: key);

  @override
  _LoansState createState() => _LoansState();
}

class _LoansState extends State<Loans> {
  TextEditingController target = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController purpose = TextEditingController();
  var _currentSelectedValue;
  var _currencies = [
    "1 Months",
    "3 Months",
    "6 Months",
    "12 Months",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aquire loan",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
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
              labelText: "Amount",
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
          Text("Tap to select repayment plan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),

          SizedBox(height: 15,),
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
            height: 233,
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
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Error",
                        desc: "You have to be a member for more that 6 months to get a loan",
                        buttons: [],
                      ).show();
                    },
                    child: Text("Enter"),
                  ))),
        ],
      ),
    ));
  }
}
