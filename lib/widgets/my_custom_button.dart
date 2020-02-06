import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class MyCustomButton extends StatelessWidget {
  String _title;
  Function _onPressed;
  bool show;

  MyCustomButton(this._title, this._onPressed, {this.show = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: RaisedButton(
        color: Colors.black,
        child: show
            ? Center(
                child: LoadingBouncingLine.circle(
                  size: 20,
                  backgroundColor: Colors.greenAccent,
                  duration: Duration(milliseconds: 900),
                ),
              )
            : Text(
                _title,
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
        onPressed: _onPressed,
      ),
    );
  }
}
