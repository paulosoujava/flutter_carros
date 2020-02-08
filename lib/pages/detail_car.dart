import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/api/loripsum_api.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/service/favorite_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class DetailCar extends StatefulWidget {
  Car c;

  DetailCar(this.c);

  @override
  _DetailCarState createState() => _DetailCarState();
}

class _DetailCarState extends State<DetailCar> {
  final _bloc = LoripsumBloc();

  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();
    FavoritoService.isFavorito(widget.c).then((fav){
      updateHeart(fav);
    });
    _bloc.fetch();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          imageCar(widget.c.urlFoto),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
          _content(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              color: Colors.white,
            ),
          ),
          _description(),
        ],
      ),
    );


  }

  _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Text(
          "Descrição\n",
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: _bloc.stream,
          builder: (c, s) {
            if (!s.hasData) {
              return Center(
                child: LoadingBouncingGrid.circle(
                  size: 45,
                  inverted: true,
                  backgroundColor: Colors.greenAccent,
                  duration: Duration(milliseconds: 900),
                ),
              );
            }
            return Text(
              s.data,
              style: TextStyle(
                fontSize: 15,
              ),
            );
          },
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  _content() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.c.nome,
              maxLines: 1,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Tipo: ${widget.c.tipo}",
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: _color,
              ),
              onPressed: _onClickFavorito,
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){},
            ),
          ],
        ),
      ],
    );
  }

  imageCar(String url) {
    return CachedNetworkImage(
      imageUrl: url ??
          "http://www.livroandroid.com.br/livro/carros/esportivos/Maserati_Grancabrio_Sport.png",
      width: 250,
      height: 250,
      placeholder: (context, url) => SizedBox(
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

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  updateHeart(bool isFavorito){
    setState(() {
      _color = isFavorito ? Colors.red : Colors.white;
    });
  }

  void _onClickFavorito() async {
    bool isFavorito = await FavoritoService.favoritar(widget.c, context);
     updateHeart(isFavorito);
  }
}
