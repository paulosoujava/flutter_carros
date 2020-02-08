import 'package:carros/pages/car_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleListTypeCar extends StatelessWidget {
  String type;

  SingleListTypeCar(this.type);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(type.toUpperCase()),
      ),
      body: CarPage(type),
    );
  }
}
