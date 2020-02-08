import 'dart:async';

import 'package:carros/entity/car.dart';
import 'package:carros/pages/favorito_model.dart';
import 'package:carros/widgets/error.dart';
import 'package:carros/widgets/my_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {

  int idx;

  FavoritePage(this.idx);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin<FavoritePage> {
  List<Car> cars;



  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    FavoritoModel model = Provider.of<FavoritoModel>(context, listen: false);
    model.fetch();
  }

  @override
  Widget build(BuildContext context) {
    FavoritoModel model = Provider.of<FavoritoModel>(context, listen: true);
    List<Car> cars = model.cars;

    if (cars.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 100),
        child: Error(
          "Lista Vazia",
          title: "Sem Favoritos",
          isEmpty: true,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.green,
      child: MyListView(cars, idx: widget.idx),
    );
  }

  Future<void> _onRefresh() {
    return Provider.of<FavoritoModel>(context, listen: false).fetch();
  }
}
