import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomInputText extends StatelessWidget {
  String title;
  String hint;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;
  bool isPass;

  MyCustomInputText(
      this.title, this.hint, this.controller, this.validator, this.keyboardType,
      {this.textInputAction,
      this.focusNode,
      this.nextFocus,
      this.isPass = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.cyanAccent,
      keyboardAppearance: Brightness.dark,
      textInputAction: textInputAction,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onFieldSubmitted: (String str) {
        if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
      },
      validator: validator,
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        labelText: title,
        hintText: hint,
      ),
    );
  }
}
