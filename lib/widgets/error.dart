import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {

  String error;

  Error(this.error);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            "Oh meu Deus por que?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20  ,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Image.asset(
          'assets/error.png',
          alignment: Alignment.centerLeft,
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            error,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          ),
        )
      ],
    );
  }
}
