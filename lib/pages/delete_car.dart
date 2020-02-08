import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/api/api_response.dart';
import 'package:carros/api/car_api.dart';
import 'package:carros/api/loripsum_api.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DeleteCar extends StatefulWidget {
  Car c;

  DeleteCar(this.c);

  @override
  _DeleteCarState createState() => _DeleteCarState();
}

class _DeleteCarState extends State<DeleteCar> {
  final _bloc = LoripsumBloc();
  bool isShow = false;

  @override
  void initState() {
    super.initState();
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
              color: Colors.red,
            ),
          ),
          _content(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Divider(
              color: Colors.red,
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
            isShow
                ? Center(
                    child: LoadingBouncingLine.circle(
                      size: 20,
                      backgroundColor: Colors.greenAccent,
                      duration: Duration(milliseconds: 900),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: _onClickDeletar,
                  ),
          ],
        ),
      ],
    );
  }

  imageCar(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      width: 250,
      height: 250,
      placeholder: (context, url) => SizedBox(
        height: 90,
        width: 90,
        child: LoadingFlipping.circle(
          size: 25,
          backgroundColor: Colors.red,
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
_updateView( bool update){
  setState(() {
    isShow = update;
  });
}
  _onClickDeletar() {
    _updateView(true);

    AlertStyle alertStyle;
    _alert(context, "Você tem certeza?", () async {
      ApiResponse<bool> response = await CarAPi.delete(widget.c);

      if (response.ok) {
        alertStyle = styleAlert(Colors.green, Colors.white, Colors.white);
        Alert(
          style: alertStyle,
          type: AlertType.success,
          context: context,
          title: "Ops",
          desc: "Ação realizada com sucesso\n",
          buttons: [
            DialogButton(
              color: Colors.green,
              child: Text(
                "ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                EventBus.get(context).sendEvent(CarroEvent("carro_deleted", widget.c.tipo));
                Navigator.pop(context);
                _back();
              },
              width: 120,
            )
          ],
        ).show();
      } else {

        alertStyle = styleAlert(Colors.red, Colors.white, Colors.white);
        Alert(
          style: alertStyle,
          type: AlertType.error,
          context: context,
          image: Image.asset("assets/error.png"),
          title: "Ops",
          desc: "Falha nossa tente mais tarde\n",
          buttons: [
            DialogButton(
              color: Colors.white,
              child: Text(
                "ok",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      }
    });
  }

  AlertStyle styleAlert(Color border, Color txt, Color d) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold, color: d),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: border,
        ),
      ),
      titleStyle: TextStyle(
        color: txt,
      ),
    );
    return alertStyle;
  }

  void _back() {
    pop(context);
  }

  _alert(BuildContext context, String msg, Function callback) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Opa"),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  _updateView(false);
                  Navigator.pop(context);
                  if (callback != null) {
                    callback();
                  }
                },
              ),
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  _updateView(false);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
