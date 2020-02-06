import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class MyCustomGoogleButton extends StatelessWidget {

  Function onPressed;
  String title;


  MyCustomGoogleButton(this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return SignInButtonBuilder(
        text: title,
        icon: Icons.call_missed_outgoing,
        onPressed: () {},
    backgroundColor: Colors.black38
    );
  }
}
