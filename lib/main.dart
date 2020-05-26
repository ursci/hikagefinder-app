import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/MapEntry.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MapEntry(),
    );
  }
}
