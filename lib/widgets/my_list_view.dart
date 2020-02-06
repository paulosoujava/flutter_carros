import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/pages/main_detail_car.dart';
import 'package:carros/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';


class MyListView extends StatelessWidget {
  List<Car> cars;

  MyListView(this.cars);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: cars != null ? cars.length : 0,
        itemBuilder: (context, idx) {
          Car c = cars[idx];
          return Container(
            padding: EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: imageCar(c.urlFoto),
                    ),
                    Text(
                      c.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      c.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Detalhes'),
                          onPressed: () {
                            push(context, MainDetailCar(c));
                          },
                        ),
                        FlatButton(
                          child: const Text('Share'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  imageCar(String url) {
    return CachedNetworkImage(
      imageUrl: url ??
          "http://www.livroandroid.com.br/livro/carros/esportivos/Maserati_Grancabrio_Sport.png",
      width: 250,
      placeholder: (context, url) =>
          SizedBox(
            height: 90,
            width: 90,
            child: LoadingBouncingGrid.circle(
              size: 25,
              backgroundColor: Colors.greenAccent,
              duration: Duration(milliseconds: 900),
            ),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

