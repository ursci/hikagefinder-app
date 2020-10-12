import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hikageapp/pages/SplashPage.dart';
import 'package:flutter_launcher_icons/android.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: 'Hikage Route Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SplashPage(),
    );
  }
}
