import 'package:carros/entity/user.dart';
import 'package:carros/pages/home.dart';
import 'package:flutter/material.dart';

import 'guillotine_menu.dart';

class Guillotine extends StatefulWidget {
  User user;


  Guillotine(this.user);

  @override
  _GuillotineState createState() => _GuillotineState();
}

class _GuillotineState extends State<Guillotine> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: new Container(
        child: new Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
             Home(),
             GuillotineMenu(widget.user),
          ],
        ),
      ),
    );
  }
}