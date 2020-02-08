import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/api/api_response.dart';
import 'package:carros/bloc/login_bloc.dart';
import 'package:carros/pages/guillotine.dart';
import 'package:carros/utils/util.dart';
import 'package:carros/widgets/my_custom_button.dart';
import 'package:carros/widgets/my_custom_google_buton.dart';
import 'package:carros/widgets/my_custom_input_Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  var _tLogin = TextEditingController();

  var _tSenha = TextEditingController(text: "123");

  var _formKey = GlobalKey<FormState>();

  var _focusPass = FocusNode();


  final _bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: containerForm(),
    );
  }

  ListView containerForm() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        Center(
          child: CachedNetworkImage(
            imageUrl:
                "https://cdn.pixabay.com/photo/2016/04/01/11/10/automobile-1300231_960_720.png",
            placeholder: (context, url) => SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                backgroundColor: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        MyCustomInputText("Login", "digite o login", _tLogin, validateLogin,
            TextInputType.emailAddress,
            textInputAction: TextInputAction.next, nextFocus: _focusPass),
        SizedBox(
          height: 10,
        ),
        MyCustomInputText(
          "Senha",
          "digite a senha",
          _tSenha,
          validatePass,
          TextInputType.number,
          focusNode: _focusPass,
          textInputAction: TextInputAction.done,
          isPass: true,
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            StreamBuilder<bool>(
              stream: _bloc.stream,
              builder: (ctx, snap) {
                return MyCustomButton(
                  "login",
                  _onPressed,
                  show:snap.data ?? false,
                );
              },
            ),
          ],
        ),
        SizedBox(
          height: 45,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "----------------",
              style: TextStyle(color: Colors.cyanAccent, fontSize: 20),
            ),
            Text(
              "  OU  ",
              style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "----------------",
              style: TextStyle(color: Colors.cyanAccent, fontSize: 20),
            ),
          ],
        ),
        SizedBox(
          height: 45,
        ),
        Container(
          alignment: Alignment(0.0, 0.0),
          child: MyCustomGoogleButton("Sign up with Google", () {}),
        ),
      ],
    );
  }

  Future _onPressed() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {

      ApiResponse response = await _bloc.doLogin(_tLogin.text, _tSenha.text);
      if (response.ok) {
        push(context, Guillotine(response.result), replace: true);
      } else {
        defaultAlert(context, "Ops", response.msg, AlertType.warning);
      }
    }
  }

  String validateLogin(String str) {
    if (str.isEmpty) {
      return "ops cade o login?";
      //else if (!str.contains("@") || !(str.contains(".com"))) {
      //return "login inválido";
    } else {
      return null;
    }
  }

  String validatePass(String str) {
    if (str.isEmpty)
      return "ai ai ai cade a senha";
    else if (str.length < 3)
      return "senha errada";
    else {
      return null;
    }
  }
  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
