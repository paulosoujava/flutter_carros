import 'package:carros/entity/user.dart';
import 'package:carros/pages/guillotine.dart';
import 'package:carros/pages/home.dart';
import 'package:carros/pages/login.dart';
import 'package:carros/pages/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:
        Colors.blue,
        brightness: Brightness.dark
      ),
      home: Splash(),
    );
  }


}
