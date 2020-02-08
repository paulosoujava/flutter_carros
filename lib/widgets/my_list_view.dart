import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/api/api_response.dart';
import 'package:carros/api/car_api.dart';
import 'package:carros/entity/car.dart';
import 'package:carros/pages/delete_car.dart';
import 'package:carros/pages/main_detail_car.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/prefs.dart';
import 'package:carros/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:nice_button/nice_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';

class MyListView extends StatefulWidget {
  List<Car> cars;
int idx;
  MyListView(this.cars, {this.idx = 0});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  int tabIdx;
  @override
  void initState() {
    super.initState();
    Prefs.getInt("tabIdx").then((idx) {
      tabIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      child: ListView.builder(
        itemCount: widget.cars != null ? widget.cars.length : 0,
        itemBuilder: (context, idx) {
          Car c = widget.cars[idx];
          return Container(
            padding: EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                push(context, MainDetailCar(c));
              },
              onLongPress: () {
                print(tabIdx);
                if (tabIdx == 3) {
                  alert(context,
                      "Função somente para as abas: Classicos, Esportivos e Luxo");
                } else {
                  _onClickDeletar(context, c);
                }
              },
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
                        c.tipo,
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
                              Share.share("Olha este carro: ${c.nome}");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
      imageUrl: url,
      width: 250,
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

  _onClickDeletar(context, Car c) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "O que deseja fazer",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    NiceButton(
                      mini: true,
                      icon: Icons.share,
                      background: Colors.black,
                      onPressed: () {
                        pop(context);
                        Share.share("Olha este carro: ${c.nome}");
                      },
                    ),
                    NiceButton(
                      mini: true,
                      icon: Icons.delete,
                      background: Colors.black,
                      onPressed: () {
                        pop(context);
                        _deletar(context, c);
                      },
                    ),
                    NiceButton(
                      mini: true,
                      icon: Icons.visibility,
                      background: Colors.black,
                      onPressed: () {
                        pop(context);
                        push(context, MainDetailCar(c));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  _deletar(context, Car c) {
    AlertStyle alertStyle;
    _alert(context, "Você tem certeza?", () async {
      ApiResponse<bool> response = await CarAPi.delete(c);

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
                EventBus.get(context)
                    .sendEvent(CarroEvent("carro_deleted", c.tipo));
                Navigator.pop(context);
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
                  Navigator.pop(context);
                  if (callback != null) {
                    callback();
                  }
                },
              ),
              FlatButton(
                child: Text("Não"),
                onPressed: () {
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
