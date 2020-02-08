import 'dart:async';

import 'package:carros/db/base_dao.dart';
import 'package:carros/entity/car.dart';

// Data Access Object
class CarDAO extends BaseDAO<Car> {

  @override
  String get tableName => "Car";

  @override
  Car fromMap(Map<String, dynamic> map) {
    return Car.fromMap(map);
  }

  Future<List<Car>> findAllByTipo(String tipo)  {
    return query('select * from $tableName where tipo =? ', [tipo]);
  }
}