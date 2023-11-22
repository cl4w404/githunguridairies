import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_dairies/admin/add__user.dart';
import 'package:g_dairies/admin/admin_index.dart';
import 'package:g_dairies/admin/single-user.details.dart';
import 'package:g_dairies/admin/user_details.dart';
import 'package:g_dairies/screens/landin.dart';
import 'package:g_dairies/screens/logReg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:g_dairies/screens/transaction/keys.dart';
import 'package:g_dairies/screens/verify.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
final auth = FirebaseAuth.instance;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MpesaFlutterPlugin.setConsumerKey(kConsumerKey);
  MpesaFlutterPlugin.setConsumerSecret(kConsumerSecret);


  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBBqDB1Tb1OSxcqOVCS8zIsfGblsaDWejE",
            appId: "1:1075337256760:web:ccd92d9e9bbb632572ebcd",
            messagingSenderId: "1075337256760",
            projectId: "sem3-e5826",
            storageBucket: "gs://sem3-e5826.appspot.com",
        ),

    );
  }else if(Platform.isAndroid){
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (_) => MyHomePage(),
        '/adminHome': (_) => SidebarXExampleApp(),
        '/userhome': (_) => Landin(),
        '/RegisterUser': (_) => AddUser(),
        '/UserDetails':(_)=> UserDetails(),
        '/SingleUser':(_)=> SingleUserDetails(uid: '',),
        '/Verify': (_)=> VerifyUser(),

      },
    );
  }
}
