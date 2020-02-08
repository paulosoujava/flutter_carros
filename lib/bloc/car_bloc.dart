import 'dart:async';

import 'package:carros/api/car_api.dart';
import 'package:carros/bloc/generic_bloc.dart';
import 'package:carros/db/car_dao.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/utils/network.dart';

class CarBloc extends GenericBloc<List<Car>> {
  Future<List<Car>> fetch(String tipo) async {
    try {
      List<Car> cars;
      bool netWorkIn = await isNetwork();

      if (!netWorkIn) {
        cars = await CarDAO().findAllByTipo(tipo);
      } else {
        cars = await CarAPi.getCars(tipo);
        if (cars.isNotEmpty) {
          final dao = CarDAO();
          cars.forEach(dao.save);
        }
      }

      add(cars);
      return cars;
    } catch (e) {
      addError("Eu devia ter estudado mais...");
    }
  }
}
