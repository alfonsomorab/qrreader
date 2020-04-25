import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
import 'package:qrreaderapp/src/pages/map_details_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: 'home',
      routes: {
        'home'   : (BuildContext context) => HomePage(),
        'map'   : (BuildContext context) => MapDetailsPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.orange
      ),
    );
  }
}
