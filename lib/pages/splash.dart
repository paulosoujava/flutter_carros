import 'package:carros/db/db_helper.dart';
import 'package:carros/entity/user.dart';
import 'package:carros/pages/guillotine.dart';
import 'package:carros/pages/home.dart';
import 'package:carros/pages/login.dart';
import 'package:carros/pages/welcome/welcomePage.dart';
import 'package:carros/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    DatabaseHelper.getInstance().db;

    splash(context);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          "Flutter",
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  void splash(BuildContext context) {
    Future<User> future = User.get();
    future.then((User u) {
      if (u != null)
          push(context, Guillotine(u), replace: true);
        else
          push(context, Login(), replace: true);
    });
  }
}
