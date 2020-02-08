import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/api/api_response.dart';
import 'package:carros/api/car_api.dart';
import 'package:carros/api/loripsum_api.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class Mapa extends StatefulWidget {
  Car c;

  Mapa(this.c);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  GoogleMapController mapController;

  Car get car => widget.c;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: latlng(),
          zoom: 12,
        ),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: true,
        markers: Set.of(_getMarkers()),
      ),
    );
  }

  // Retorna os marcores da tela.
  List<Marker> _getMarkers() {
    return [
      Marker(
        markerId: MarkerId("1"),
        position: latlng(),
        infoWindow:
            InfoWindow(title: car.nome, snippet: "Fábrica do ${car.nome}"),
        onTap: () {
          print("> ${car.nome}");
        },
      )
    ];
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  latlng() {
    return car.latlng;
  }
}
