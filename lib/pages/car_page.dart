import 'dart:async';

import 'package:carros/bloc/car_bloc.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/widgets/my_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:carros/widgets/error.dart';

class CarPage extends StatefulWidget {
  String tipo;

  CarPage(this.tipo);

  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage>
    with AutomaticKeepAliveClientMixin<CarPage> {
  List<Car> cars;
  final CarBloc _bloc = CarBloc();

  @override
  bool get wantKeepAlive => true;

  String get tipo => widget.tipo;

  @override
  void initState() {
    super.initState();
    _bloc.fetch(tipo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Error(snapshot.error),
                ],
              ),
            );
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Por favor aguarde...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  LoadingBouncingLine.circle(
                    size: 45,
                    backgroundColor: Colors.greenAccent,
                    duration: Duration(milliseconds: 900),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: Colors.green,
            child: MyListView(snapshot.data),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  Future<void> _onRefresh() {
    return _bloc.fetch(tipo);
  }
}
