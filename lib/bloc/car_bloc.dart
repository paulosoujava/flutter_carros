import 'dart:async';

import 'package:carros/api/car_api.dart';
import 'package:carros/bloc/generic_bloc.dart';
import 'package:carros/entity/car.dart';

class CarBloc  extends GenericBloc<List<Car>>{

  Future<List<Car>>fetch(String tipo) async {
    try {
      List<Car> cars = await CarAPi.getCars(tipo);
      add(cars);
      return cars;
    } catch (e) {
      addError("Eu devia ter estudado mais...");
    }
  }
}
