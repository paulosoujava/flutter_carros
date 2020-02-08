import 'package:carros/db/entity.dart';
import 'package:carros/entity/car.dart';

class Favorito extends Entity {
  int id;
  String nome;

  Favorito.fromCar(Car c){
    this.id = c.id;
    this.nome = c.nome;
  }

  Favorito.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }
}
