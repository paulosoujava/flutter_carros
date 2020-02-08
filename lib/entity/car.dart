import 'dart:convert' as convert;

import 'package:carros/db/entity.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarroEvent extends Event{
  String action;
  String type;

  CarroEvent(this.action, this.type);

  @override
  String toString() {
    return 'CarroEvent{action: $action, type: $type}';
  }


}

class Car extends Entity {
  int id;
  String nome;
  String tipo;
  String descricao;
  String urlFoto;
  String urlVideo;
  String latitude;
  String longitude;

  Car(
      {this.id,
      this.nome,
      this.tipo,
      this.descricao,
      this.urlFoto,
      this.urlVideo,
      this.latitude,
      this.longitude});

  Car.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome']?? "";
    tipo = map['tipo']?? "";
    descricao = map['descricao']?? "";
    urlFoto = map['urlFoto']??  "http://www.livroandroid.com.br/livro/carros/esportivos/Maserati_Grancabrio_Sport.png";
    urlVideo = map['urlVideo']?? "";
    latitude = map['latitude']?? "";
    longitude = map['longitude']?? "";
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['tipo'] = this.tipo;
    data['descricao'] = this.descricao;
    data['urlFoto'] = this.urlFoto;
    data['urlVideo'] = this.urlVideo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }

  @override
  String toString() {
    return 'Car{id: $id, nome: $nome, tipo: $tipo, descricao: $descricao, urlFoto: $urlFoto, urlVideo: $urlVideo, latitude: $latitude, longitude: $longitude}';
  }

  get latlng => LatLng(
      latitude == null || latitude.isEmpty ? 0.0 : double.parse(latitude),
      longitude == null || longitude.isEmpty ? 0.0 : double.parse(longitude)
  );
}
