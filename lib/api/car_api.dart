import 'dart:convert' as convert;
import 'dart:io';

import 'package:carros/api/api_response.dart';
import 'package:carros/api/upload_api.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/utils/http_helper.dart' as http;

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
      var response = await http.get(url);
      List<Car> cars = convert.json
          .decode(response.body)
          .map<Car>((c) => Car.fromMap(c))
          .toList();

      return cars;
    } catch (error) {
      throw error;
    }
  }

  static Future<ApiResponse<bool>> save(Car c, File file) async {
    try {

      if(file != null) {
        ApiResponse<String> response = await UploadApi.upload(file);
        if(response.ok) {
          String urlFoto = response.result;
          c.urlFoto = urlFoto;
        }
      }

      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros';
      if (c.id != null) {
        url += "/${c.id}";
      }

      print("POST > $url");

      String json = c.toJson();

      print("   JSON > $json");

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);

        Car carro = Car.fromMap(mapResponse);

        print("Novo carro: ${carro.id}");

        return ApiResponse.ok(true);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error("Não foi possível salvar o carro");
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(mapResponse["error"]);
    } catch (e) {
      print(e);

      return ApiResponse.error("Não foi possível salvar o carro");
    }
  }

  static Future<ApiResponse<bool>> delete(Car c) async {
    try {
      var url = 'https://carros-springboot.herokuapp.com/api/v2/carros/${c.id}';

      print("DELETE > $url");

      var response = await http.delete(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return ApiResponse.ok(true);
      }

      return ApiResponse.error("Não foi possível deletar o carro");
    } catch (e) {
      print(e);

      return ApiResponse.error("Não foi possível deletar o carro");
    }
  }
}
