import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/screens/account.dart';
import 'package:g_dairies/screens/home.dart';
import 'package:g_dairies/screens/savings.dart';
import 'package:g_dairies/screens/savings_main.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'loans.dart';

class Landin extends StatefulWidget {
  Landin({Key? key}) : super(key: key);

  @override
  _LandinState createState() => _LandinState();
}

class _LandinState extends State<Landin> {
  var _currentIndex = 0;
  final screen=[
    Home(),
    SavingsMain(),
    Loans(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),

              selectedColor: Colors.blue.shade900,
              activeIcon: Icon(CupertinoIcons.home),
              unselectedColor: Colors.blue.shade400
          ),

          /// Likes
          SalomonBottomBarItem(
              icon: Icon(Icons.savings_outlined),
              title: Text("Savings"),
              selectedColor: Colors.blue.shade900,
              activeIcon: Icon(Icons.savings),
              unselectedColor: Colors.blue.shade400
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle),
            title: Text("Loans"),
            activeIcon: Icon(CupertinoIcons.money_dollar),

            selectedColor: Colors.blue.shade900,
            unselectedColor: Colors.blue.shade400
            ,
          ),

          /// Profile
          SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.person),
              title: Text("Account"),

              selectedColor: Colors.blue.shade900,
              unselectedColor: Colors.blue.shade400
          ),
        ],
      ),
      body:Container(
        color: Colors.blue.shade50,
        child: screen[_currentIndex],
      ) ,
    );
  }
}