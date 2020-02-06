import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


Future push(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  } else {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}


defaultAlert(BuildContext context, String title, String desc, AlertType type) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.white,
    ),
  );

  return Alert(
    style: alertStyle,
    context: context,
    title: title,
    type: type,
    desc: desc,
    buttons: [
      DialogButton(
        color: Colors.white,
        child: Text(
          "Entendi",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}


