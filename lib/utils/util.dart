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

bool pop<T extends Object>(BuildContext context, [T result]){
  return Navigator.pop(context);
}

defaultAlert(BuildContext context, String title, String desc, AlertType type, {bool img = false}) {
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

  if(img)
    return Alert(
      style: alertStyle,
      context: context,
      title: title,
      desc: desc,
      image: Image.asset("assets/error.png"),
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "ok",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: ()=> Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
    else
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


alert(BuildContext context, String msg, {Function callback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Opa"),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if(callback != null) {
                  callback();
                }
              },
            )
          ],
        ),
      );
    },
  );
}