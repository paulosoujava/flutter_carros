import 'package:carros/db/car_dao.dart';
import 'package:carros/db/favoritoDAO.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/entity/favorito.dart';
import 'package:carros/pages/favorito_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FavoritoService {
  static Future<bool> favoritar(Car c, BuildContext context) async {
    final dao = FavoritoDAO();
    final exist = await dao.exists(c.id);
    if (exist) {
      dao.delete(c.id);
      Provider.of<FavoritoModel>(context,listen: false).fetch();
      ;
      return false;
    } else {
      dao.save(Favorito.fromCar(c));
      Provider.of<FavoritoModel>(context,listen: false).fetch();
      return true;
    }
  }

  static Future<List<Car>> getCar() async {
    return await CarDAO()
        .query("select * from car c,favorito f where c.id = f.id");
  }

  static Future<bool> isFavorito(Car c) async {
    final dao = FavoritoDAO();
    return await dao.exists(c.id);
  }
}
