import 'package:carros/entity/car.dart';
import 'package:carros/service/favorite_service.dart';
import 'package:flutter/material.dart';

class FavoritoModel extends ChangeNotifier {
  List<Car> cars = [];

  Future<List<Car>> fetch() async {
    cars = await FavoritoService.getCar();

    notifyListeners();

    return cars;
  }
}
