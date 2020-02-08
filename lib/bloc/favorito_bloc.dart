import 'dart:async';

import 'package:carros/bloc/generic_bloc.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/service/favorite_service.dart';

class FavoritoBloc extends GenericBloc<List<Car>> {
  Future<List<Car>> fetch() async {
    try {
      List<Car> cars;

      cars = await FavoritoService.getCar();
      add(cars);
      return cars;
    } catch (e, exc) {
      addError("Eu devia ter estudado mais...$e $exc");
    }
  }
}
