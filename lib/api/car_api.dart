import 'dart:convert';

import 'package:carros/entity/car.dart';
import 'package:carros/entity/user.dart';
import 'package:http/http.dart' as http;

class TypeCar {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";
}

class CarAPi {
  static Future<List<Car>> getCars(String tipo) async {
    try {
      var url =
          'http://carros-springboot.herokuapp.com/api/v2/carros/tipo/$tipo';
      User user = await User.get();

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user.token}"
      };
      var response = await http.get(url, headers: headers);
      return json
          .decode(response.body)
          .map<Car>((c) => Car.fromJson(c))
          .toList();
    } catch (error, exception) {
      throw error;
    }
  }
}
